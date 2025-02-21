# Chrono Time

A marketplace to find your designer watch.

## Getting Started

This project is combination for _**Mobile Application Development**_ and
_**Multimedia Project Management**_ (University course)
> Created with the help of each team members, Zulhafif, Nabil and Lutfil

---

> [!IMPORTANT]
> First things to setup
> - Run _flutter pub get_ to get all of the dependencies
> - Make sure you create and connect to your own FireBase project and Google Cloud Platform
> - Download and put the required file inside each platform directory like iOS[ios/Runner/], Android [android/app/]
> - You can modify to your own need and compatible sdk version in android/app/src/build.gradle
> - This project build specifically for Android. You need to change the layout according to your platform if needed
> - It runs locally only. You may add your online server service for it to work anywhere
> - The structure of the code is quite messy. You may refactor it according to your own need with your kind of app

---

## Guide to open setup the server:

Create server.js
```javascript
// server.js
const express = require('express');
const stripe = require('stripe')('your-test-id');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Create a payment intent
app.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency = 'myr' } = req.body;

    // Create a PaymentIntent with the order amount and currency
    const paymentIntent = await stripe.paymentIntents.create({
      amount: parseInt(amount), // Amount in cents
      currency: currency,
      payment_method_types: ['card'],
    });

    // Send the client secret to the client
    res.json({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

```

To set this up:

1. Create a new directory for your backend:
```bash
mkdir watch-store-backend
cd watch-store-backend
```

2. Initialize a new Node.js project:
```bash
npm init -y
```

3. Install the required dependencies:
```bash
npm install express stripe cors dotenv
```

4. Create a `.env` file to store your Stripe secret key:
```
STRIPE_SECRET_KEY=[your-stripe-secret-key]
PORT=3000
```

Now, update your Flutter code to use this backend:

```dart
// In your Flutter app, update the API URL to point to your backend
final response = await http.post(
  Uri.parse('http://your-backend-url:3000/create-payment-intent'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'amount': (totalAmount * 100).toInt().toString(), // Convert to cents
    'currency': 'myr',
  }),
);
```

---

To test this:

1. Start your backend server:
```bash
node server.js
```

2. Run your Flutter app and attempt a payment.

> [!NOTE]
> In test mode, you can use Stripe's test card numbers:
>
> 4242 4242 4242 4242 - Success payment
>
> 4000 0027 6000 3184 - Requires authentication (3D Secure)
>
> 4000 0000 0000 9995 - Declined payment

You can use any future expiration date, any 3-digit CVC, and any postal code.
To process real payments, you would need to:
___

Switch to live mode in your Stripe dashboard
Use live keys (starting with sk_live_ and pk_live_)
Replace the test keys in both your backend and frontend code
___

## Navigate to the database
When using sqflite in a Flutter application, the database file is stored in the app's internal storage. Here are the steps to locate the SQLite database file on both Android and iOS:

For Android Emulator:
>Open Android Device Monitor:
In Android Studio, go to View > Tool Windows > Device File Explorer.
Navigate to the Database File:

In the Device File Explorer, navigate to the following path:
Replace <your_app_package_name> with the actual package name of your app (e.g., com.example.chrono_time).
Locate the Database File:

> [!TIP]
> You should see your database file (`app_database.db` if
> you followed the naming convention in the code).

---

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### License
This repository is licensed under the MIT License.