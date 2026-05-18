# 🎉 LoanBee - Feature Showcase

## 🏠 Home Screen
- **Beautiful Grid Layout** with 7 calculator cards
- **App Icon** displayed in header (cute bee with calculator)
- **Dark/Light Mode Toggle** in top-right corner
- **Each card** shows icon, title, and description
- **Color-coded** features for easy identification

## 📊 Calculators Implemented

### 1. 💰 EMI Calculator
**Color**: Orange
**Purpose**: Calculate loan EMI (Equated Monthly Installment)
**Inputs**:
- Loan Amount (₹)
- Interest Rate (%)
- Loan Tenure (years)

**Outputs**:
- Monthly EMI
- Total Payment
- Total Interest
- **Pie Chart**: Principal vs Interest breakdown

---

### 2. ✅ Loan Eligibility
**Color**: Green
**Purpose**: Check loan eligibility based on income
**Inputs**:
- Monthly Income (₹)
- Existing EMI (₹)
- Interest Rate (%)
- Loan Tenure (years)
- FOIR - Fixed Obligation to Income Ratio (%)

**Outputs**:
- Eligible Loan Amount
- Maximum EMI
- Eligibility Status (✓ or ✗)
- Detailed message

---

### 3. 📈 SIP Calculator
**Color**: Blue
**Purpose**: Calculate mutual fund SIP returns
**Inputs**:
- Monthly Investment (₹)
- Expected Return Rate (%)
- Investment Period (years)

**Outputs**:
- Total Invested Amount
- Estimated Returns
- Total Maturity Value
- **Pie Chart**: Investment vs Returns

---

### 4. 🏦 FD/RD Calculator
**Color**: Purple
**Purpose**: Calculate Fixed/Recurring Deposit returns
**Toggle**: Switch between FD and RD

**FD Inputs**:
- Principal Amount (₹)
- Interest Rate (%)
- Tenure (months)
- Compounding Frequency (Annual/Half-Yearly/Quarterly/Monthly)

**RD Inputs**:
- Monthly Deposit (₹)
- Interest Rate (%)
- Tenure (months)

**Outputs**:
- Maturity Amount
- Total Interest
- Principal/Invested Amount

---

### 5. 🧾 GST Calculator
**Color**: Red
**Purpose**: Calculate GST and taxes
**Inputs**:
- Amount (₹)
- GST Rate (%) with quick select (5%, 12%, 18%, 28%)
- **Toggle**: Amount includes/excludes GST

**Outputs**:
- Original Amount
- GST Amount
- CGST (Central GST)
- SGST (State GST)
- Total Amount

---

### 6. 💱 Currency Converter
**Color**: Teal
**Purpose**: Convert between world currencies
**Features**:
- 10+ currencies (USD, EUR, GBP, INR, JPY, AUD, CAD, CHF, CNY, AED)
- Real-time exchange rates from API
- Currency swap button
- Refresh rates button
- Shows current exchange rate
- Fallback to default rates if API unavailable

**Inputs**:
- Amount
- From Currency
- To Currency

**Output**:
- Converted Amount with currency symbol
- Current exchange rate

---

### 7. 📅 Amortization Schedule
**Color**: Indigo
**Purpose**: View complete loan payment schedule
**Inputs**:
- Loan Amount (₹)
- Interest Rate (%)
- Loan Tenure (years)

**Outputs**:
- Complete month-by-month schedule
- **For each month**:
  - Month number
  - EMI amount
  - Principal payment
  - Interest payment
  - Remaining balance
- **Expandable cards** for detailed view
- **Year-end highlights** with special background color

---

## 🌗 Dark Mode
- **Toggle button** in app bar (☀️/🌙 icon)
- **Persistent**: Settings saved across app sessions
- **Beautiful themes**:
  - **Light**: Clean white cards, grey background
  - **Dark**: Dark grey cards, black background
- **All screens** fully support both themes
- **Charts** adapt to theme colors

---

## 🎨 Design Elements

### Colors
- **Primary**: Orange (#FF8C42)
- **Secondary**: Yellow (#FFD93D)
- **Dark Background**: #1A1A1A
- **Dark Surface**: #2D2D2D

### Typography
- **Font**: Poppins (Google Fonts)
- **Styles**: Clean, modern, readable

### Components
- **Cards**: Rounded corners (16px), elevated shadows
- **Buttons**: Rounded (12px), orange with white text
- **Inputs**: Filled style, rounded borders, focus indicators
- **Charts**: Interactive pie charts with percentages

---

## 🚀 Technical Highlights

- ✅ **Zero compilation errors**
- ✅ **Clean code analysis** (no warnings)
- ✅ **Proper architecture** (MVC pattern)
- ✅ **State management** (Provider)
- ✅ **Responsive design**
- ✅ **Error handling**
- ✅ **Input validation**
- ✅ **Number formatting** (Indian currency format)
- ✅ **API integration** (Currency rates)
- ✅ **Local storage** (Theme preference)

---

## 📱 Ready to Use!

Run the app with:
```bash
flutter run
```

All features are fully functional and ready for testing! 🎊
