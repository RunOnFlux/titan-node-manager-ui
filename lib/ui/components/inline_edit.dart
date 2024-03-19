import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/save_node.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class InlineTextEdit extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback reset;
  final NodeInfo node;

  const InlineTextEdit(
      {Key? key,
      required this.node,
      required this.controller,
      required this.reset})
      : super(key: key);

  @override
  _InlineTextEditState createState() => _InlineTextEditState();
}

class _InlineTextEditState extends State<InlineTextEdit> {
  late TextEditingController _controller;
  bool _isEditing = false;
  late VoidCallback _reset;
  late NodeInfo _node;
  // final String initialText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _reset = widget.reset;
    _node = widget.node;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing ? _buildTextField() : _buildText();
  }

  Widget _buildText() {
    return GestureDetector(
      onTap: () => setState(() {
        _isEditing = true;
      }),
      child: Text(_controller.text),
    );
  }

  // void updateNodeName() {
  //   // final node = getIt<App>().node;
  //   final newNode = NodeInfo(
  //     name: _controller.text,
  //   );
  //   getIt<App>().updateNode(newNode);
  // }

  Widget _buildTextField() {
    return TextField(
      autofocus: true,
      controller: _controller,
      onSubmitted: (newValue) {
        // node.name = newValue;
        updateName();
        setState(() {
          print('_node.name in onSubmitted: ${_node.name}');
          _isEditing = false;
        });
        _reset();

      },
      // Optional: Customize your TextField's appearance, behavior, etc.
    );
  }

  void updateName() {
    print('before: ${_node.name}');
    var inputs = {
      'name': _controller.text,
      'provider': _node.provider,
      'price': _node.price.toString(),
    };
    saveNode(_node, inputs, _reset);
    _node.name = _controller.text;
    print('after: ${_node.name}');
  }

  String getNewName() {
    // print('in get name: ${_controller.text}');
    return _controller.text;
  }
}
