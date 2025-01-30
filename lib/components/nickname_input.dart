import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pixel_button.dart';
import 'background_scaffold.dart';
import 'pixel_container.dart';

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
    return BackgroundScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),  // Wywołuje funkcję budującą nagłówek
            const SizedBox(height: 30),  // Odstęp między nagłówkiem a polem tekstowym
            _buildNicknameInput(),  // Buduje pole tekstowe do wpisania nazwy gracza
            const SizedBox(height: 30),  // Odstęp między polem tekstowym a przyciskiem
            _buildPlayButton(),  // Buduje przycisk "Play"
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,  // Centruje elementy w poziomie
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),  // Ikona strzałki wstecz
          onPressed: widget.onBack,  // Akcja po naciśnięciu przycisku
        ),
        const SizedBox(width: 10),  // Odstęp między przyciskiem wstecz a nagłówkiem
        Align(
          alignment: Alignment.center,  // Centruje nagłówek w poziomie
          child: PixelContainer(
            backgroundColor: const Color(0xFF123d8c),  // Kolor tła nagłówka
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),  // Wewnętrzne odstępy w nagłówku
              child: Text(
                'Wpisz nazwę gracza',  // Tekst nagłówka
                style: GoogleFonts.inter(
                  fontSize: 40,  // Rozmiar czcionki nagłówka
                  color: Colors.white,  // Kolor czcionki nagłówka
                  fontWeight: FontWeight.w800,  // Grubość czcionki nagłówka
                ),
                textAlign: TextAlign.center,  // Wyśrodkowanie tekstu w nagłówku
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNicknameInput() {
    return SizedBox(
      width: 300,  // Szerokość pola tekstowego
      child: TextField(
        controller: _nicknameController,
        decoration: InputDecoration(
          hintText: 'Enter your nickname',  // Tekst podpowiedzi w polu tekstowym
          hintStyle: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),  // Zaokrąglone rogi pola tekstowego
            borderSide: BorderSide.none,  // Brak obramowania
          ),
          filled: true,
          fillColor: const Color(0xFFB8FFF1),  // Kolor tła pola tekstowego
        ),
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,  // Wyśrodkowanie tekstu w polu tekstowym
      ),
    );
  }

  Widget _buildPlayButton() {
    return PixelButton(
      text: "Play",  // Tekst przycisku
      onPressed: () {
        final nickname = _nicknameController.text.trim();
        if (nickname.isNotEmpty) {  // Sprawdza, czy pole tekstowe nie jest puste
          widget.onSetPlayerName(nickname);  // Akcja po naciśnięciu przycisku
        }
      },
      width: 300,  // Szerokość przycisku
      height: 70,  // Wysokość przycisku
      fontSize: 40,  // Rozmiar czcionki przycisku
    );
  }
}