# CustomRefreshControl 使用说明

这是一个可复用的iOS风格下拉刷新组件，具有精美的动画效果和触觉反馈。

## 特性

- ✅ iOS原生风格的下拉刷新动画
- ✅ 向下箭头渐变显示和缩放效果
- ✅ 触发时的弹性动画和颜色变化
- ✅ 触觉反馈（HapticFeedback）
- ✅ 完全可自定义的触发距离
- ✅ 适配安全区域（刘海屏）

## 基本用法

```dart
import '../widgets/custom_refresh_control.dart';

// 在CustomScrollView中使用
CustomScrollView(
  slivers: [
    // 添加下拉刷新组件
    CustomRefreshControl(
      onRefresh: _handleRefresh,
    ),

    // 其他Sliver组件...
    CupertinoSliverNavigationBar(
      largeTitle: Text('页面标题'),
    ),

    SliverList(...),
  ],
)

// 刷新处理函数
Future<void> _handleRefresh() async {
  // 执行刷新逻辑（网络请求等）
  await Future.delayed(Duration(seconds: 1));

  // 更新UI状态
  setState(() {
    // 更新数据
  });
}
```

## 自定义参数

```dart
CustomRefreshControl(
  onRefresh: _handleRefresh,
  refreshTriggerPullDistance: 70.0,  // 触发刷新的下拉距离（默认60.0）
  refreshIndicatorExtent: 70.0,     // 刷新指示器的显示高度（默认60.0）
)
```

## 参数说明

| 参数                         | 类型                      | 默认值 | 说明                     |
| ---------------------------- | ------------------------- | ------ | ------------------------ |
| `onRefresh`                  | `Future<void> Function()` | 必需   | 刷新时调用的异步函数     |
| `refreshTriggerPullDistance` | `double`                  | 60.0   | 触发刷新需要的下拉距离   |
| `refreshIndicatorExtent`     | `double`                  | 60.0   | 刷新指示器的显示区域高度 |

## 动画效果

### 下拉阶段
- 向下箭头从透明逐渐显现
- 图标大小从小到大动态变化
- 整体缩放从0.7倍到1.0倍

### 触发阶段
- 箭头颜色变为蓝色
- 弹性缩放动画（1.0倍→1.2倍→1.0倍）
- 中等强度触觉反馈

### 刷新阶段
- 显示标准的CupertinoActivityIndicator
- 箭头消失，加载动画显示

## 完整示例

查看以下文件了解完整用法：
- `lib/pages/home_page.dart` - 基础用法示例
- `lib/pages/explore_page.dart` - 列表刷新示例

## 注意事项

1. 只能在 `CustomScrollView` 的 `slivers` 中使用
2. 必须提供 `onRefresh` 回调函数
3. 组件会自动处理刷新状态，无需手动管理
4. 触觉反馈需要在真机上才能感受到效果