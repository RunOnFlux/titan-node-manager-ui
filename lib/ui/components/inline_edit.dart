import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/save_node.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class InlineTextEdit extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback reset;
  final dynamic node;

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
  late dynamic _node;

  @override
  void initState() {
    super.initState();
    // if node can be cast as Nodeinfo cast it as Nodeinfo, if it can be cast as InactiveInfo cast it as InactiveInfo
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
      onDoubleTap: () => setState(() {
        _isEditing = true;
      }),
      child: Text(
        _controller.text,
        style: TextStyle(
          color: _controller.text == 'NOT SET' ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      autofocus: true,
      controller: _controller,
      onSubmitted: (newValue) {
        updateName();
        setState(() {
          print('_node.name in onSubmitted: ${_node.name}');
          _isEditing = false;
        });
        _reset();
      },
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

}
