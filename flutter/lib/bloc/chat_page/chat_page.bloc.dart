import 'dart:convert';
import 'dart:developer';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:inject/inject.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tourists/models/chat/chat_model.dart';
import 'package:tourists/services/chat/char_service.dart';

@provide
class ChatPageBloc {
  static const STATUS_CODE_INIT = 1588;
  static const STATUS_CODE_EMPTY_LIST = 1589;
  static const STATUS_CODE_GOT_DATA = 1590;
  static const STATUS_CODE_BUILDING_UI = 1591;

  ChatService _chatService;
  ChatPageBloc(this._chatService);

  PublishSubject<Pair<int, List<ChatModel>>> _chatBlocSubject = new PublishSubject();
  Stream<Pair<int, List<ChatModel>>> get chatBlocStream => _chatBlocSubject.stream;

  // We Should get the UUID of the ChatRoom, as such we should request the data here
  getMessages(String chatRoomID) {
    log(_chatService.hashCode.toString());
    _chatService.chatMessagesStream.listen((event) {
      _chatBlocSubject.add(Pair(STATUS_CODE_GOT_DATA, event));
    });
    _chatService.requestMessages(chatRoomID);
  }

  sendMessage(String chatRoomID, String chat) {
    _chatService.sendMessage(chatRoomID, chat);
  }

  dispose() {
    _chatBlocSubject.close();
  }
}