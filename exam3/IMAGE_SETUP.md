# Gujarat Tourist Guide - Image Setup Instructions

## How to Add the Actual Images

To replace the placeholder files with your actual images, follow these steps:

### 1. Save Your Images
Save your 5 tourist place images in the `assets/images/` folder with these exact names:

- `gir_lion.jpeg` - Replace the lion image from Gir National Park
- `kutch_desert.jpeg` - Replace the Kutch desert white salt landscape image  
- `sabarmati_ashram.jpeg` - Replace the Sabarmati Ashram building image
- `somnath_temple.jpeg` - Replace the Somnath Temple image
- `statue_of_unity.jpeg` - Replace the Statue of Unity image

### 2. File Requirements
- **Format**: JPEG, PNG, or WebP (Your images are JPEG format)
- **Resolution**: Recommended 800x600 pixels or higher
- **Size**: Keep under 1MB per image for better app performance

### 3. Steps to Replace
1. Delete the `.placeholder` files in `assets/images/`
2. Copy your actual image files to `assets/images/`
3. Rename them to match the exact filenames above
4. Run `flutter pub get` to refresh assets
5. Run `flutter clean` then `flutter run` to see the images

### 4. Current Tourist Places
The app now includes only these 5 places:

1. **Statue of Unity** (Kevadia) - ₹150
2. **Somnath Temple** (Somnath) - Free
3. **Gir National Park** (Gir Forest) - ₹300
4. **Sabarmati Ashram** (Ahmedabad) - ₹50
5. **Kutch Desert** (Bhuj) - ₹200

### 5. Troubleshooting
- If images don't appear, check the file names match exactly
- Ensure images are in the correct `assets/images/` folder
- Run `flutter clean` and `flutter pub get` if needed
- Check that `pubspec.yaml` includes the assets section

The app will show placeholder graphics until you add the actual images.