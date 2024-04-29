let get_addr ip_version =
  match ip_version with
  | `V4 -> Ipaddr.V4.broadcast |> Ipaddr.V4.to_octets |> Eio.Net.Ipaddr.of_raw
  | `V6 ->
      Ipaddr.V6.Prefix.(multicast |> address)
      |> Ipaddr.V6.to_octets |> Eio.Net.Ipaddr.of_raw

(* TODO: Move to a Unix implementation? *)
let make_socket ~sw ~net addr =
  let addr =
    Eio.Net.Ipaddr.fold ~v4:(fun _v4 -> `UdpV4) ~v6:(fun _v6 -> `UdpV6) addr
  in
  let socket = Eio.Net.datagram_socket ~sw net addr in
  let sock = Eio_unix.Net.fd socket in
  Eio_unix.Fd.use_exn "datagram_socket" sock (fun fd ->
      Unix.setsockopt fd Unix.SO_BROADCAST true);
  socket

module Packet = struct
  type t = Cstruct.t list

  let wol_header =
    let buf = Cstruct.create 6 in
    Cstruct.memset buf 0xFF;
    buf

  (*
  A Wake-on-LAN "Magic Packet" consists of the following bit-pattern:
  o  Sync sequence: 48 binary 1s (i.e. 6 bytes of 0xFF)
  o  Sixteen repetitions of the 48-bit MAC address of the sleeping
  server's network interface
  o  Optional 32-bit or 48-bit 'password'
*)
  let make mac_addr : t =
    let mac_addr_buf =
      Macaddr.of_string_exn mac_addr |> Macaddr_cstruct.to_cstruct
    in
    let packet = wol_header :: List.init 16 (fun _ -> mac_addr_buf) in
    packet
end

let standard_port = 7

let send ~sw ~net ?(ip_version = `V4) ?(port = standard_port) mac_addr =
  let addr = get_addr ip_version in
  let socket = make_socket ~sw ~net addr in
  let packet = Packet.make mac_addr in
  Eio.Net.send socket ~dst:(`Udp (addr, port)) packet
