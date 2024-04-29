let rec check_status ~sw ~net ip count =
  try
    let addr : Eio.Net.Sockaddr.stream =
      `Tcp
        ( Ipaddr.of_string_exn ip |> Ipaddr.to_octets |> Eio.Net.Ipaddr.of_raw,
          22 )
    in
    print_endline ("Connecting to " ^ ip);
    let connection = Eio.Net.connect ~sw net addr in
    print_endline "Connected, host is up";
    Eio.Net.close connection
  with _ ->
    print_endline
      "Connection failed, waiting for the host to come up before retry";
    Eio_unix.sleep 3.;
    print_endline ("Trying connection again, count" ^ string_of_int count);
    check_status ~sw ~net ip (count + 1)

let main mac_addr ip =
  Eio_main.run @@ fun env ->
  let net = Eio.Stdenv.net env in
  Eio.Switch.run @@ fun sw ->
  Wol.send ~sw ~net mac_addr;
  match ip with
  | None -> ()
  | Some ip ->
    Eio.Switch.run @@ fun sw -> check_status ~sw ~net ip 0

open Cmdliner

let mac_addr =
  let doc = "Mac address of target computer." in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"MAC" ~doc)

let check =
  let doc = "Check the $(docv) if target is up." in
  Arg.(value & opt (some string) None & info [ "c"; "check" ] ~docv:"IP" ~doc)

let main_t = Term.(const main $ mac_addr $ check)
let cmd = Cmd.v (Cmd.info "wol") main_t
let () = exit (Cmd.eval cmd)
