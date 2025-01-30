import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pixel_button.dart';
import 'background_scaffold.dart';

class NicknameInput extends StatefulWidget {
  final void Function(String) onSetPlayerName;

  const NicknameInput({required this.onSetPlayerName, Key? key}) : super(key: key);

  @override
  State<NicknameInput> createState() => _NicknameInputState();
}

class _NicknameInputState extends State<NicknameInput> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNicknameInput(),
          const SizedBox(height: 30),
          _buildPlayButton(),
        ],
      ),
    );
  }

  Widget _buildNicknameInput() {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: _nicknameController,
        decoration: InputDecoration(
          hintText: 'Enter your nickname',
          hintStyle: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFB8FFF1),
        ),
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPlayButton() {
    return PixelButton(
      text: "Play",
      onPressed: () {
        final nickname = _nicknameController.text.trim();
        if (nickname.isNotEmpty) {
          widget.onSetPlayerName(nickname);
        }
      },
      width: 300,
      height: 70,
      fontSize: 40,
    );
  }
}