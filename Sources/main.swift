import Foundation
import Socket

func connect(to ip: String, port: Int32, timeout: UInt) throws {
  let socket = try Socket.create()
  try socket.setBlocking(mode: false)

  let start = Date()
  print("connecting...")
  try socket.connect(to: ip, port: port)
  defer { socket.close() }

  print("checking read/writeable...")
  let res = try socket.isReadableOrWritable(waitForever: false, timeout: timeout)
  let elapsed = Date().timeIntervalSince(start)
  print(elapsed, res)
}

let args = CommandLine.arguments
guard args.count == 4 else {
  print("usage: \(args.first ?? "") ip port timeout-in-ms")
  exit(1)
}

guard let port = Int32(args[2]) else {
  print("port must be numeric")
  exit(2)
}
guard let timeout = UInt(args[3]) else {
  print("timeout must be numeric")
  exit(3)
}

do {
  try connect(to: args[1], port: port, timeout: timeout)
} catch {
  print("final error: \(error)")
}

