import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pixel_button.dart';
import 'background_scaffold.dart';
import 'pixel_container.dart';

class DifficultySelection extends StatelessWidget {
  final void Function(double, double) onSetDifficulty;
  final VoidCallback onBack;

  const DifficultySelection({required this.onSetDifficulty, required this.onBack, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),  // Wywołuje funkcję budującą nagłówek
            const SizedBox(height: 30),  // Odstęp między nagłówkiem a przyciskami
            _buildDifficultyButton("Easy", 150, 250),  // Buduje przycisk "Easy"
            const SizedBox(height: 20),  // Odstęp między przyciskami
            _buildDifficultyButton("Medium", 400, 390),  // Buduje przycisk "Medium"
            const SizedBox(height: 20),  // Odstęp między przyciskami
            _buildDifficultyButton("Hard", 700, 600),  // Buduje przycisk "Hard"
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
          onPressed: onBack,  // Akcja po naciśnięciu przycisku
        ),
        const SizedBox(width: 10),  // Odstęp między przyciskiem wstecz a nagłówkiem
        Align(
          alignment: Alignment.center,  // Centruje nagłówek w poziomie
          child: PixelContainer(
            backgroundColor: const Color(0xFF123d8c),  // Kolor tła nagłówka
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),  // Wewnętrzne odstępy w nagłówku
              child: Text(
                'Wybierz poziom',  // Tekst nagłówka
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

  Widget _buildDifficultyButton(String text, double speed, double pipeSpawnDistance) {
    return PixelButton(
      text: text,  // Tekst przycisku
      onPressed: () {
        onSetDifficulty(speed, pipeSpawnDistance);  // Akcja po naciśnięciu przycisku
      },
      width: 300,  // Szerokość przycisku
      height: 70,  // Wysokość przycisku
      fontSize: 40,  // Rozmiar czcionki przycisku
    );
  }
}