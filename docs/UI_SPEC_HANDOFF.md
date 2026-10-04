# 🎨 UI Specification & Developer Handoff Document

**Project**: `ecormmerce_ma` (E-Commerce Mobile Application)  
**Figma Project**: [Midterm_Project (Node 0-1)](https://www.figma.com/design/dl4o6saDvaGYd1NlyAHR6N/Midterm_Project?node-id=0-1&p=f&t=NQeCZMfIH4fqwamG-0)  
**Target Viewport**: iPhone 16 & 17 Pro Max (`440 x 956 px`)  
**Design System Language**: High-end Fashion E-Commerce (Minimalist, Editorial, Luxury typography)  
**Author**: Generated via Antigravity Agent Inspection

---

## 1. 🌈 Design System Tokens

### 1.1 Color Palette

| Token Name | Hex Code | Flutter `Color` Representation | Usage / Role |
| :--- | :--- | :--- | :--- |
| **Primary Black** | `#000000` | `Color(0xFF000000)` | Main buttons, primary headers, active tab icons |
| **Primary White** | `#FFFFFF` | `Color(0xFFFFFFFF)` | Background, cards, inverted text on buttons |
| **Background Neutral** | `#F9FAFB` / `#FBFBFB` | `Color(0xFFF9FAFB)` | App background, section backgrounds |
| **Border & Divider** | `#ECECEC` / `#D9D9D9` | `Color(0xFFECECEC)` | Outline borders, list dividers, card strokes |
| **Text Secondary / Muted** | `#6B7280` / `#959595` | `Color(0xFF6B7280)` | Captions, subtitle copy, inactive tab labels |
| **Placeholder / Disabled** | `#9CA3AF` / `#BCBCBC` | `Color(0xFF9CA3AF)` | Input hints, disabled buttons |
| **Accent Terracotta** | `#864433` | `Color(0xFF864433)` | Accent banners, luxury brand labels, highlight tags |
| **Error / Alert / Sale** | `#E74C3C` / `#FB0000` | `Color(0xFFE74C3C)` | Sale badges, error states, delete actions |
| **Soft Rose Tint** | `#F9B8B8` | `Color(0xFFF9B8B8)` | Promotional badges, discount pill backgrounds |
| **Social Google Blue** | `#4285F4` | `Color(0xFF4285F4)` | Google authentication branding |
| **Social Google Green** | `#34A853` | `Color(0xFF34A853)` | Google authentication branding |
| **Social Google Yellow**| `#FBBC05` | `Color(0xFFFBBC05)` | Google authentication branding |
| **Social Google Red**   | `#EA4335` | `Color(0xFFEA4335)` | Google authentication branding |

---

### 1.2 Typography Hierarchy

| Style Role | Font Family | Weight | Size | Line Height | Usage in UI |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Display / Hero Title** | `Playfair Display` | Bold (700) | `30px` / `28px` | `1.2` | Screen titles ("Sign In", "New In", Editorial Headings) |
| **Section Header** | `Poppins` | SemiBold (600) | `20px` | `1.3` | Section titles ("Categories", "Recommended", "My Bag") |
| **Product Title** | `Poppins` / `Inter` | Medium (500) | `16px` | `1.3` | Product names on detail screen and cards |
| **Body Primary** | `Inter` | Regular (400) | `14px` | `1.5` | Form inputs, description body, item details |
| **Button Text** | `Inter` / `Poppins` | Bold (700) / SemiBold | `12px` / `14px`| `1.2` | All-caps buttons ("SIGN IN", "ADD TO BAG", "CHECKOUT") |
| **Form Label** | `Inter` | Bold (700) | `11px` | `1.2` | Uppercase field headers ("EMAIL ADDRESS", "PASSWORD") |
| **Badge / Caption** | `Inter` | SemiBold (600) | `10px` - `12px` | `1.2` | Sale tags ("30%-70% OFF"), category chip labels |
| **Micro Labels** | `Inter` | Light (300) / Regular | `8px` | `1.2` | Sub-category navigation labels ("Women", "Men", "Kids") |

---

### 1.3 Spacing & Layout Metrics

* **Grid Base**: 4pt / 8pt grid system.
* **Screen Padding**: `horizontal: 20px`, `vertical: 16px`.
* **Card Corner Radius**:
  * Input fields: `borderRadius: BorderRadius.circular(8)` or `circular(4)` (clean sharp luxury look).
  * Product Cards: `BorderRadius.circular(12)`.
  * CTA Buttons: `BorderRadius.circular(8)` or full pill `BorderRadius.circular(30)`.
  * Bottom Sheet Modal: `BorderRadius.vertical(top: Radius.circular(24))`.
* **Elevation / Shadows**:
  * Luxury flat aesthetic: Minimal elevation (`elevation: 0`), subtle border strokes (`1px solid #ECECEC`), and soft blur shadows (`BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))`).

---

## 2. 📱 Screen Inventory & Structural Specifications

### 2.1 Onboarding Flow
* **Figma Nodes**: `iPhone 16 & 17 Pro - 1` through `6` (Nodes `2:510` to `2:576`)
* **Layout**: Full-screen image/carousel hero with editorial imagery (`Rectangle 1`).
* **Components**:
  * Top status bar & skip button.
  * Dot indicator (`indecator` component) showing current step (1 to 6).
  * Main headline & brief onboarding tagline.
  * Primary navigation buttons: "Next" / "Get Started" on the 6th screen leading directly to Sign In / Sign Up.

---

### 2.2 Authentication Flow

#### A. Sign In Screen (`iPhone 16 & 17 Pro Max - 4` / Node `20:2726`)
* **Components**:
  1. **Top Nav**: Back arrow button and top branding carousel banner.
  2. **Header**: 
     * Title: `Sign In` (`Playfair Display`, 30px, Bold).
     * Subtitle: `Enter your credentials to continue` (`Inter`, 14px, #6B7280).
  3. **`SignInForm`**:
     * Email Field: Label `EMAIL ADDRESS` (`Inter`, 11px, Bold, Uppercase), placeholder `name@example.com`.
     * Password Field: Label `PASSWORD`, right-aligned `Forgot?` text action (`Inter`, 12px, Medium).
     * Obscured text field with toggle visibility eye icon.
     * Primary Button: `SIGN IN` (Full width, #000000 background, #FFFFFF text, height ~50px).
  4. **`Divider:margin`**: Subtle line with text `Or continue with`.
  5. **`SocialAuth:margin`**: Outlined social buttons for Google (multicolor G), Apple (black apple icon), and Facebook.
  6. **`FooterLinks`**: "Don't have an account? " + bold link "Sign Up" navigating to registration.

#### B. Sign Up / Registration Screen (`iPhone 16 & 17 Pro Max - 3` / Node `20:2663`)
* **Components**:
  1. **Header**: Brand logo (`logoDevs`), `Create Account` headline, subtitle.
  2. **`RegistrationForm`**:
     * Full Name field (`FULL NAME`).
     * Email field (`EMAIL ADDRESS`).
     * Password field (`PASSWORD`) with strength indicator.
     * Confirm Password field (`CONFIRM PASSWORD`).
     * Terms and conditions checkbox ("I agree to Terms & Conditions and Privacy Policy").
     * Primary Button: `CREATE ACCOUNT` (Full width, Black).
  3. **Social Sign Up & Footer**: Similar social auth row + "Already have an account? Sign In".

---

### 2.3 Main Application Shell & Navigation
* **Figma Components**: `Nav` (Node `20:2502`), `nav-value` (`20:2407`), `menu bar` (`66:2553`)
* **Bottom Navigation Tabs**:
  1. **Home** (`Icons.home_outlined` / active solid)
  2. **Explore / Categories** (`Icons.grid_view` / `fluent:layout-cell-four`)
  3. **Wishlist** (`akar-icons:heart` / active filled)
  4. **Bag / Cart** (`Icons.shopping_bag_outlined` with badge counter)
  5. **Profile** (`Icons.person_outline`)

---

### 2.4 Home Screen (`home-page/women` / Node `20:2578`)
* **Dimensions**: `440 x 4200 px` (Scrollable editorial feed)
* **Structure**:
  1. **Top Bar**: Search bar input, notification bell, shopping bag icon.
  2. **Gender Selector Segment Tabs**: `Women` (active underline), `Men`, `Kids`, `Home`, `Beauty`.
  3. **Hero Carousel** (`carousel` / Node `20:907`, `20:1543`):
     * Promotional banner: "30%-70% OFF SALE ENDS SOON EXT"
     * CTA pill button: "Shop Now" / "Buy Ticket"
     * Dot indicator (`indecator`)
  4. **Offers Section** (`offer-label` / Node `24:2908`): Horizontal scrolling flash discount vouchers.
  5. **Category Quick-Nav Grid** (`two-col`, `fluent:layout-cell-four-20-regular`):
     * 2-column or 4-cell tiles with category image, title, and item count.
  6. **New In / Trending Section** (`Card-new-In` / Node `127:1426`):
     * Product cards with image, favorite heart icon toggle, brand title, price, discount badge.
  7. **Featured Brands** (`Brand` / Node `38:679`): Editorial horizontal carousel of partner brands.
  8. **Footer Section** (`end-home` / Node `38:796`): Newsletter sign up, return guarantee, customer care links.

---

### 2.5 Product Listing & Search (`Product List Screen` / `women-search` / `Filter`)
* **Figma Nodes**: `149:1607`, `140:2730`, `160:2030`
* **Features**:
  1. **Search Header**: Auto-suggest text search bar with clear button.
  2. **Subcategory Filter Chips**: Horizontal list (e.g., "Dresses", "Tops", "Shoes", "Jackets").
  3. **Toolbar**:
     * Item count ("124 items found")
     * Layout switcher (2-column grid vs 1-column detailed list)
     * Sort dropdown (Price Low-to-High, Newest, Popularity)
     * "Filter" button (triggers bottom sheet/screen `Filter` Node `160:2030`).
  4. **Filter Sheet (`Filter Box` / Node `171:2149`)**:
     * Range slider for Price ($0 - $500+)
     * Size selection chips (XS, S, M, L, XL)
     * Color swatch circles
     * Brand checkboxes
     * "Reset All" & "Apply Filters" buttons

---

### 2.6 Product Detail Screen (`product-detail-screen` / Node `77:690`)
* **Dimensions**: `440 x 2700 px`
* **Features**:
  1. **Header Navigation**: Back button, share icon, and wishlist favorite toggle (`akar-icons:heart`).
  2. **Image Gallery**: Large hero carousel with pinch-to-zoom and multi-angle indicators.
  3. **Product Metadata**:
     * Brand Name (`Inter`, 12px, Uppercase, Muted).
     * Product Title (`Poppins`, 18px, SemiBold).
     * Rating row (Stars, Review count).
     * Price display: Current Price (`$XX.XX`), Original strikethrough price, and Discount percentage pill.
  4. **Color & Variant Selector** (`sel-items`, `selected-clothes` / Node `127:1065`):
     * Circular color swatches with active selection border ring.
  5. **Size Selector**:
     * Size chips (XS, S, M, L, XL, XXL)
     * Size Guide link opening `size-guide` modal (`163:6147`) and `size-overlay` (`180:2180`).
  6. **Collapsible Information Sections** (`Delivery-list` / Node `127:793`):
     * Description & details
     * Delivery, shipping & return policy
     * Material & wash care
  7. **Bottom Action Bar (Sticky)**:
     * Quantity picker modal trigger (`qty-overlay` / Node `127:1775`).
     * `ADD TO BAG` primary full-width button with shopping bag icon.

---

### 2.7 Shopping Bag & Checkout (`shopping-bag-screen` / `bag-verify`)
* **Figma Nodes**: `140:1142`, `140:2423`, `140:1112`
* **Features**:
  1. **Top Bar**: "Shopping Bag (X Items)".
  2. **Delivery Address Bar**: Quick display of selected delivery location with "Change" button.
  3. **Cart Items List (`cart-item` / `cart-item-wishlist`)**:
     * Product thumbnail image.
     * Name, selected color, selected size.
     * Unit price and total.
     * Quantity stepper: `[-] 1 [+]`.
     * Swipe to delete / Remove modal confirmation (`shopping-bag-screen/remove`).
     * "Move to Wishlist" action link.
  4. **Voucher / Promo Code Field**: Input with "Apply" button.
  5. **Order Breakdown Card**:
     * Subtotal
     * Estimated Shipping
     * Discount applied
     * **Total Amount** (Bold, prominent)
  6. **Checkout CTA**:
     * "PROCEED TO CHECKOUT" button leading to `bag-verify` step.

---

### 2.8 Wishlist Screen (`wishlist` / Node `178:2071`)
* **Features**:
  * Empty state graphic ("Your wishlist is empty") with a "Start Shopping" button.
  * Populated grid: 2-column product cards with a quick "Move to Bag" or "Remove from Wishlist" action.

---

### 2.9 User Profile Screen (`User Profile` / Node `131:856`)
* **Features**:
  1. **Profile Header**:
     * Avatar picture with camera change icon (`ant-design:camera-outlined` / Node `131:1418`).
     * User name and verified email (`name@gmail.com`).
     * "Edit Profile" button.
  2. **Account Menu List**:
     * My Orders (with badge for in-transit orders)
     * Shipping Addresses (saved addresses list)
     * Payment Methods (saved cards / Apple Pay / Google Pay)
     * Notifications & App Settings
     * Privacy & Security
     * Help Center & FAQs
  3. **Sign Out**: Red-accented "Log Out" action with confirmation bottom sheet.

---

## 3. 🧩 Reusable Component Architecture

The Flutter codebase should map to the Figma components as follows:

```
lib/
├── helpers/
│   ├── app_colors.dart          # All extracted hex tokens (Primary, Neutral, Accent, Social)
│   ├── app_typography.dart      # TextStyles for Playfair Display, Poppins, Inter
│   └── app_constants.dart       # Margins, paddings, border radiuses, API constants
├── models/
│   ├── user_model.dart          # User profile data
│   ├── product_model.dart       # Product, variants (colors, sizes), images, rating
│   ├── category_model.dart      # Category taxonomy
│   ├── cart_item_model.dart     # Cart item with quantity, selected size, and color
│   └── order_model.dart         # Order status and checkout models
├── widgets/
│   ├── custom_button.dart       # Full-width primary black luxury button with loading state
│   ├── custom_text_field.dart   # Clean bordered text field with uppercase floating label
│   ├── product_card.dart        # Reusable Card-new-In with favorite heart toggle
│   ├── carousel_banner.dart     # PageView banner with custom dot indecators
│   ├── quantity_stepper.dart    # Minus/Plus quantity selector
│   └── bottom_nav_bar.dart      # Custom minimalist bottom navigation
├── screens/
│   ├── onboarding/              # 6-step walkthrough screens
│   ├── auth/
│   │   ├── sign_in_screen.dart
│   │   ├── sign_up_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── main_navigation.dart     # IndexedStack shell with BottomNavigationBar
│   ├── home/
│   │   └── home_screen.dart
│   ├── product/
│   │   ├── product_list_screen.dart
│   │   ├── product_detail_screen.dart
│   │   └── filter_bottom_sheet.dart
│   ├── bag/
│   │   ├── shopping_bag_screen.dart
│   │   └── checkout_screen.dart
│   ├── wishlist/
│   │   └── wishlist_screen.dart
│   └── profile/
│       └── profile_screen.dart
```

---

## 4. 📦 Recommended Dependencies (`pubspec.yaml`)

To implement this specification smoothly, the following packages will be added:

1. **`google_fonts: ^6.2.1`**: For immediate access to `Playfair Display`, `Poppins`, and `Inter`.
2. **`supabase_flutter: ^2.8.0`**: Backend authentication, database, and storage integration.
3. **`flutter_riverpod: ^2.6.1`** (or `provider`): Reactive state management for Cart, Wishlist, and Auth.
4. **`cached_network_image: ^3.4.1`**: Efficient image caching with placeholder shimmer effects.
5. **`flutter_svg: ^2.0.17`**: Direct SVG rendering for Figma icons.
6. **`go_router: ^14.8.0`**: Clean URL-based and declarative page routing.

---

## 5. 🛠 Step-by-Step Implementation Roadmap

* [ ] **Phase 1: Foundation & Design Tokens**
  * Configure `pubspec.yaml` with Google Fonts and core packages.
  * Create `AppColors`, `AppTypography`, and `AppTheme` matching Figma.
* [ ] **Phase 2: Authentication & Onboarding**
  * Implement Onboarding PageView with dot indicators.
  * Implement `SignInScreen` and `SignUpScreen` with form validation.
  * Connect to Supabase Auth.
* [ ] **Phase 3: Core Navigation & Home Page**
  * Build bottom navigation bar shell.
  * Build Home screen: Promotional carousel, category grid, and new-in cards.
* [ ] **Phase 4: Product Discovery & Details**
  * Product list screen with search, sort, and filter bottom sheet.
  * Product detail screen with image gallery, color/size picker, and size guide modal.
* [ ] **Phase 5: Bag, Wishlist & Checkout**
  * Cart state management (add, remove, update quantity, compute total).
  * Wishlist state toggle.
  * Shopping bag screen and checkout order verification.
* [ ] **Phase 6: User Profile & Polish**
  * User profile screen, order history listing, and account options.
  * Micro-animations, responsive layout adjustments, and UI QA against Figma.
