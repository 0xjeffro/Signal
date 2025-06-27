# Widgets 组件库

这个目录包含了 Signal 应用中使用的自定义组件。

## 组件列表

### 📱 页面组件

#### `custom_tab_bar.dart`
- **功能**: 自定义iOS风格底部标签栏
- **特性**: 支持图标、文字、选中状态动画
- **使用场景**: 应用主要导航界面

#### `draggable_bottom_sheet.dart`
- **功能**: 可拖拽的底部面板组件
- **特性**: 支持手势拖拽、自动吸附、平滑动画
- **使用场景**: 弹出式内容展示

#### `custom_refresh_control.dart`
- **功能**: 自定义下拉刷新控件
- **特性**: iOS风格设计、自定义动画效果
- **使用场景**: 列表页面的下拉刷新功能

### 🎯 信号展示组件

#### `enhanced_signal_card.dart` ⭐ 核心组件
- **功能**: 统一的增强信号卡片，支持所有类型的信号展示
- **适用信号类型**:
  - 🐋 巨鲸交易信号
  - 👑 KOL喊单信号  
  - 📰 新闻/分析信号
  - 🔔 自定义信号类型

**特性**:
- **完全灵活的数据结构**: 信号开发者可以自定义任意字段和内容
- **Follow-up更新系统**: 支持信号的后续跟进和更新展示
- **智能渲染**: 根据数据类型自动优化显示效果
- **可展开/收起**: 超过2个更新时支持展开查看全部
- **iOS风格设计**: 完美适配系统暗黑模式

**数据结构**:
```dart
// 基础信号数据
{
  'channel': '信号来源',          // 必需
  'channelColor': Color,         // 可选：频道颜色
  'channelIcon': IconData,       // 可选：频道图标
  'title': '信号标题',           // 必需
  'subtitle': '副标题',          // 可选
  'content': '详细内容',         // 可选
  'time': DateTime,              // 必需：信号时间
  'views': int,                  // 可选：观看数
  'followers': int,              // 可选：跟单数
  'customData': Map,             // 可选：自定义数据展示
  'updates': List,               // 可选：Follow-up更新列表
}

// Follow-up更新数据
{
  'title': '更新标题',
  'description': '更新描述',
  'time': DateTime,
  'icon': IconData,              // 可选：更新图标
  'color': Color,                // 可选：更新颜色
  'data': Map,                   // 可选：额外数据
}
```

**使用示例**:
```dart
EnhancedSignalCard(
  signal: {
    'channel': '0x7f...a9e2',
    'channelColor': CupertinoColors.systemBlue,
    'title': 'BTC/USDT',
    'subtitle': 'LONG Position',
    'time': DateTime.now(),
    'customData': {
      'Entry': 45000.0,
      'Size': 100000.0,
      'Leverage': 5.0,
      'Side': 'LONG',
    },
    'updates': [
      {
        'title': 'Position Added',
        'description': 'Increased position size',
        'time': DateTime.now(),
        'data': {'Amount': '\$25K'},
      }
    ],
  },
  onTap: () => Navigator.push(...),
)
```

### 🔧 工具组件

所有组件都遵循以下设计原则：
- ✅ iOS风格设计语言
- ✅ 支持暗黑模式自动适配
- ✅ 类型安全的Dart代码
- ✅ 可复用和可配置
- ✅ 性能优化

## 设计系统

### 颜色规范
- 使用 `CupertinoColors` 系统颜色
- 支持自动暗黑模式切换
- 语义化颜色命名

### 字体规范
- 标题：16pt, FontWeight.w600
- 副标题：14pt, FontWeight.w500  
- 正文：14pt, FontWeight.normal
- 辅助文字：12pt

### 间距规范
- 大间距：16pt
- 中间距：12pt
- 小间距：8pt
- 微间距：4pt

### 圆角规范
- 卡片圆角：12pt
- 按钮圆角：8pt
- 标签圆角：16pt