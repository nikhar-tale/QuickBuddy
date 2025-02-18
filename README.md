# Quick Buy E-Commerce App

A Flutter-based e-commerce application that demonstrates a complete production-level setup including:

- **GraphQL API Integration:** Fetching product and cart data from Shopify’s Storefront API.
- **Real-Time Dynamic Styling:** Using Firebase Firestore to load and update UI style settings on the fly.
- **Local Caching:** Caching product data locally with Hive for fast UI load times and offline support.
- **State Management:** Utilizing the BLoC pattern (with flutter_bloc and equatable) for clean separation of business logic and UI.
- **Modular Folder Structure:** Organizing code into features (home, cart) and core services (GraphQL, Firebase, Hive) to enhance scalability and maintainability.
- **Responsive UI:** With a Bottom Navigation Bar to switch between Home and Cart screens.


## Features

- **Home Screen**: Displays products in a grid.
- **Cart Screen**: Shows a read-only list of cart items with total pricing.
- **Dynamic Styling**: Card colors, fonts, borders, etc., are fetched from Firebase Firestore in real time.
- **Local Caching**: Product data is cached locally using Hive for fast UI loading and offline support.
- **GraphQL Integration**: Uses Shopify's GraphQL endpoint to retrieve products and cart details.
- **State Management**: Utilizes BLoC for a clear separation between business logic and UI.

---
## Libraries and Frameworks

 - **Flutter SDK(3.24.4)**: For building the mobile application.
 - **flutter_bloc & equatable**: For state management using the BLoC pattern.
 - **graphql_flutter**: For executing GraphQL queries against Shopify’s API.
 - **Firebase** (firebase_core, cloud_firestore): For real-time dynamic styling data.
 - **Hive & hive_flutter**: For local caching of product data.
 - **cached_network_image**: For optimized image loading.
 - **fluttertoast**: For displaying quick toast notifications.

## Setup

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/quick_buy.git
   cd quick_buy

2. **Install Dependencies**:  
    ```bash
    flutter pub get
 
3. **Run the App**:
     ```bash
     flutter run

