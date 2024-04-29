val standard_port : int

val send :
  sw:Eio.Switch.t ->
  net:[ `Generic | `Unix ] Eio.Net.ty Eio.Resource.t ->
  ?ip_version:[< `V4 | `V6 > `V4 ] ->
  ?port:int ->
  string ->
  unit

module Packet : sig
  type t
  (**
      A Wake-on-LAN "Magic Packet" consists of the following bit-pattern:
      o  Sync sequence: 48 binary 1s (i.e. 6 bytes of 0xFF)
      o  Sixteen repetitions of the 48-bit MAC address of the sleeping
      server's network interface
      o  Optional 32-bit or 48-bit 'password'
      *)

  val make : string -> t
  (** mac_addr -> t *)
end
