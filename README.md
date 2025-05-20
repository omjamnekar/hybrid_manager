# Nutrito

**Nutrito** is a powerful Flutter plugin designed to analyze food ingredient lists and instantly rate the health impact of packaged food products. It uses machine learning to identify harmful or beneficial ingredients and helps users make smarter, healthier food choices.

---

##  Features

- 🔍 Scan and analyze ingredient lists
- ⚖️ Get real-time health ratings (e.g., Healthy, Moderate, Unhealthy)
- 💡 Understand what each ingredient means
- 🧠 Backed by machine learning for smarter suggestions
- 📊 Feedback ratios and explanations for transparency

---

##  Getting Started

Add Nutrito to your Flutter project by including it in your `pubspec.yaml`:

```yaml
dependencies:
  nutrito: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

##  Usage

```dart
import 'package:nutrito/nutrito.dart';

void main() {
  final result = Nutrito.analyze("Ingredients: Sugar, Palm Oil, Salt, Turmeric");
  print(result.healthRating); // Output: Unhealthy
  print(result.feedback);     // Output: Too much sugar and palm oil
}
```

You can also:
- Highlight harmful ingredients
- Suggest healthy alternatives
- Visualize nutritional ratios

---

##  Example Use Case

Imagine scanning the back of a snack pack. Nutrito can instantly tell you if it’s a good choice for your health and offer better alternatives—right on your mobile device.

---

##  Technologies Used

- Flutter & Dart
- Machine Learning (for ingredient analysis)
- Flutter Secure Storage (for user data)
- Flask & MongoDB (backend)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
