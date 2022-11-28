import 'dart:io';

main() async {
  String localIp = '';
  final List<String> privateNetworkMasks = ['10', '172.16', '192.168'];
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      for (final possibleMask in privateNetworkMasks) {
        if (addr.address.startsWith(possibleMask)) {
          localIp = addr.address;
          print(localIp);
          break;
        }
      }
    }
  }
}
