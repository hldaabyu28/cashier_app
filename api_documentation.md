# Casier API Documentation

Welcome to the **Casier Express API** documentation. This API powers a Point of Sale (POS) system with authentication, product management, cart functionality, and Midtrans payment integration.

**Base URL**: `https://casier-api.vercel.app/api`  
**Development URL**: `http://localhost:5000/api`

---

## 🔐 Authentication

All protected routes require a Bearer Token in the `Authorization` header.

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/auth/register` | Register a new user |
| `POST` | `/auth/login` | Login and get JWT token |

### Login Request
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

### Authorization Header
```http
Authorization: Bearer <your_jwt_token>
```

---

## 📥 Product Management

| Method | Endpoint | Role | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/products` | User | Get all products |
| `GET` | `/products/:id` | User | Get product details |
| `POST` | `/products` | Admin | Create product (Multipart/Form-Data) |
| `PUT` | `/products/:id` | Admin | Update product |
| `DELETE` | `/products/:id` | Admin | Delete product |

### Query Parameters (GET `/products`)
- `name`: Filter by name (regex)
- `category`: Filter by category ID

---

## 🛒 Cart Management

Manage items before checkout. Automatically attached to the logged-in cashier.

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/cart` | Get current cashier's cart |
| `POST` | `/cart/add` | Add or update quantity in cart |
| `DELETE` | `/cart/remove/:productId` | Remove item from cart |
| `DELETE` | `/cart/clear` | Empty the cart |

### Add to Cart Request
```json
{
  "productId": "65f...",
  "quantity": 2
}
```

---

## 💰 Transactions & Checkout (Midtrans)

Handles both cash payments and online payments via Midtrans Snap.

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/transactions` | Yes | Create transaction (Checkout) |
| `GET` | `/transactions` | Yes | Get transaction history |
| `GET` | `/transactions/:id` | Yes | Get transaction detail |
| `POST` | `/transactions/notification` | No | Midtrans Webhook (Callback) |

### Create Transaction (Checkout)
If no `items` are provided, it will automatically use items from your **Cart**.

```json
{
  "customer": "John Doe",
  "paymentType": "midtrans",
  "discountCode": "PROMO10",
  "taxId": "65f...",
  "items": [ // Optional, uses Cart if empty
    { "productId": "65...", "quantity": 1 }
  ]
}
```

### Transaction Response (Midtrans)
If `paymentType` is `midtrans`, the response will include a `snapToken` and `snapUrl`.

```json
{
  "success": true,
  "message": "Transaksi pending, silakan selesaikan pembayaran",
  "data": {
    "orderId": "TRX-171274...",
    "total": 150000,
    "status": "pending",
    "snapToken": "xxxx-xxxx-xxxx",
    "snapUrl": "https://app.sandbox.midtrans.com/snap/v2/vtweb/..."
  }
}
```

---

## 🏷️ Discounts & Taxes

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/discounts` | Get all active discounts |
| `GET` | `/discounts/check/:code` | Validate a discount code |
| `GET` | `/taxes` | Get all taxes |
| `POST` | `/taxes` | Create new tax (Admin) |

---

## 📂 Categories

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/categories` | Get all product categories |
| `POST` | `/categories` | Create category (Admin) |

---

## 🛠️ Status Codes & Error Handling

| Code | Status | Meaning |
| :--- | :--- | :--- |
| `200` | OK | Success |
| `201` | Created | Resource created successfully |
| `400` | Bad Request | Logic error (e.g., insufficient stock) |
| `401` | Unauthorized | Missing or invalid token |
| `403` | Forbidden | Insufficient permissions (Admin only) |
| `404` | Not Found | Resource does not exist |
| `500` | Server Error | Internal server error |
