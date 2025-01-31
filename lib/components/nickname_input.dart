import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';
import 'pixel_button.dart';
import 'pixel_container.dart';
import 'menu_background.dart';

class MenuGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(MenuBackground(
      canvasSize,
      mountainsHeightRatio: 0.3,
      starsHeightRatio: 0.5,
    ));
  }
}

class NicknameInput extends StatefulWidget {
  final void Function(String) onSetPlayerName;
  final VoidCallback onBack;

  const NicknameInput({required this.onSetPlayerName, required this.onBack, Key? key}) : super(key: key);

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
    return Stack(
      children: [
        SizedBox.expand(
          child: GameWidget(
            game: MenuGame(),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildNicknameInput(),
                const SizedBox(height: 30),
                _buildPlayButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: PixelContainer(
                backgroundColor: const Color(0xFF123d8c),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'Wpisz nazwę gracza',
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Positioned(
              left: constraints.maxWidth / 2 - 270,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1be2bc)),
                onPressed: widget.onBack,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNicknameInput() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: _nicknameController,
        decoration: InputDecoration(
          hintText: 'Enter your nickname',
          hintStyle: GoogleFonts.inter(
            color: Colors.black54,
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
