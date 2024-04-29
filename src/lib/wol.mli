val wol_header : Cstruct.t
val standard_port : int

val send :
  sw:Eio.Switch.t ->
  net:[ `Generic | `Unix ] Eio.Net.ty Eio.Resource.t ->
  ?ip_version:[< `V4 | `V6 > `V4 ] ->
  ?port:int ->
  string ->
  unit
