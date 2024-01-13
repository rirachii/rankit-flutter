# Rankit Flutter App

## Prerequisites

- Flutter SDK: Make sure you have Flutter SDK installed on your machine. You can download it from the official Flutter website.

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/rirachii/rankit_flutter.git
   ```

2. Navigate to the project directory:

   ```bash
   cd rankit_flutter
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

   This will launch the app on the connected device or emulator.

### Hive Local Object Storing

The part 'list_data.g.dart'; line is where the generated code will go. You need to run the hive_generator to generate the TypeAdapter for ListData and Item. You can do this by running the following command in your terminal:

   ```bash
   flutter packages pub run build_runner build
   ```

## Contributing

If you would like to contribute to this project, please follow these steps:

1. Fork the repository.

2. Create a new branch:

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make your changes and commit them:

   ```bash
   git commit -m "Add your commit message here"
   ```

4. Push your changes to your forked repository:

   ```bash
   git push origin feature/your-feature-name
   ```

5. Open a pull request on the original repository.

## License

This project is licensed under the [MIT License](LICENSE).


### Flutter Notes
To format files: 

   ```bash
   flutter format .
   ```