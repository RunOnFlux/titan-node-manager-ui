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
  final String property;

  const InlineTextEdit(
      {Key? key,
      required this.node,
      required this.controller,
      required this.reset,
      required this.property})
      : super(key: key);

  @override
  _InlineTextEditState createState() => _InlineTextEditState();
}

class _InlineTextEditState extends State<InlineTextEdit> {
  late TextEditingController _controller;
  bool _isEditing = false;
  late VoidCallback _reset;
  late dynamic _node;
  late String _property;

  @override
  void initState() {
    super.initState();
    // if node can be cast as Nodeinfo cast it as Nodeinfo, if it can be cast as InactiveInfo cast it as InactiveInfo
    _controller = widget.controller;
    _reset = widget.reset;
    _node = widget.node;
    _property = widget.property;
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

  // not yet clicked
  Widget _buildText() {
    return GestureDetector(
      onDoubleTap: () => setState(() {
        _isEditing = true;
      }),
      child: Text(
        _property == 'Price'
            ? _formatPrice(_controller.text)
            : _controller.text,
        style: TextStyle(
          color: _controller.text == 'NOT SET' ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  // clicked and editing
  Widget _buildTextField() {
    return TextField(
      // only numbers

      inputFormatters: _property == 'Price'
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : [],
      autofocus: true,
      controller: _controller,
      // submite on click away
      onTapOutside: (e) {
        var newValue = _controller.text;
        updateNode(newValue);
        setState(() {
          _isEditing = false;
        });
        _reset();
      },
      onSubmitted: (newValue) {
        updateNode(newValue);
        setState(() {
          _isEditing = false;
        });
        _reset();
      },
    );
  }

  String _formatPrice(String price) {
    return price == 'NOT SET'
        ? price
        : '\$${double.parse(price).toStringAsFixed(2)}';
  }

  void updateNode(newValue) {
    var inputs = {
      'name': _node.name,
      'provider': _node.provider,
      'price': _node.price.toString(),
    };

    if (_property == 'Name') {
      inputs['name'] = newValue;
      _node.name = newValue;
    } else if (_property == 'Provider') {
      inputs['provider'] = newValue;
      _node.provider = newValue;
    } else if (_property == 'Price') {
      inputs['price'] = newValue;
      _node.price = double.parse(newValue);
    }

    saveNode(_node, inputs, _reset);
  }
}
