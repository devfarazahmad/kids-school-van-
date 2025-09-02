enum MessageSender { parent, driver }


class Message {
final String id;
final MessageSender sender;
final String text;
final DateTime timestamp;


Message({
required this.id,
required this.sender,
required this.text,
required this.timestamp,
});
}