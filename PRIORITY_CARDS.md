# 🎯 Priority Card Order - HARDCODED

## ✅ Cards That Load Perfectly (Always First)

These 6 startups **ALWAYS** appear first, in this exact order:

1. **CleanAir** 🌱 - Climate Tech
2. **MindfulAI** 🧠 - Mental Health
3. **RoboChef** 🤖 - FoodTech
4. **StyleSwap** 👗 - Fashion
5. **SleepTech** 😴 - HealthTech
6. **VoiceClone** 🎙️ - AI Voice

---

## 🔧 Implementation

### **In SwipeDeckViewModel:**

```swift
// PRIORITY: Always show these 6 working startups first
let priorityStartupNames = ["CleanAir", "MindfulAI", "RoboChef", "StyleSwap", "SleepTech", "VoiceClone"]
let priorityStartups = priorityStartupNames.compactMap { name in
    startups.first(where: { $0.name == name })
}
let remainingStartups = startups.filter { startup in
    !priorityStartupNames.contains(startup.name)
}

// Combine: priority first, then others
startups = priorityStartups + remainingStartups
```

### **Applied To:**
1. ✅ `loadInitial()` - First batch of cards
2. ✅ `replenish()` - When loading more cards (every 3 swipes)

---

## 📊 Queue Order (Debug Console)

When you run the app, you'll see:

```
🎯 PRIORITY QUEUE ORDER:
1. CleanAir (Climate Tech)
2. MindfulAI (Mental Health)
3. RoboChef (FoodTech)
4. StyleSwap (Fashion)
5. SleepTech (HealthTech)
6. VoiceClone (AI Voice)
7. [Other startups sorted by algorithm]
8. [Other startups sorted by algorithm]
... etc
```

---

## 🔄 Algorithm Still Works

After the first 6 priority cards:
- ✅ Remaining 14 cards sorted by user preferences
- ✅ Algorithm learns from swipes
- ✅ Re-sorts on replenishment
- ✅ Priority cards cycle back first on replenish

---

## 🧪 Testing

1. **Rebuild:** Cmd + B
2. **Run:** Cmd + R
3. **First 6 cards:** Will ALWAYS be the priority ones in order
4. **Swipe through them:** All should render perfectly
5. **After card 6:** Algorithm-sorted cards appear
6. **After 3 more swipes:** Replenish triggers, priority cards appear first again

---

## 🐛 If Issues Persist

If even these 6 cards don't render:

### **Possible Causes:**
1. **Xcode cache issue:**
   - Clean Build Folder (Shift + Cmd + K)
   - Delete Derived Data
   - Rebuild

2. **Simulator issue:**
   - Restart simulator
   - Delete app from simulator
   - Reinstall

3. **SwiftUI rendering issue:**
   - Add `.id()` modifier to force re-render
   - Add `.onAppear()` to debug lifecycle

### **Debug Steps:**
```swift
// In StartupCardView, add:
.onAppear {
    print("🎨 RENDERING CARD: \(startup.name)")
    print("   Sector: \(startup.sector)")
    print("   Growth Data: \(startup.monthlyGrowthData)")
    print("   Match Score: \(startup.similarityScore)")
}
```

---

## 📝 Next Steps

Once we confirm these 6 work perfectly:
1. Debug why the other 14 don't render
2. Compare data structure differences
3. Fix remaining cards to match working ones
4. Remove hardcoded priority

For now: **These 6 will ALWAYS appear first!** ✅

