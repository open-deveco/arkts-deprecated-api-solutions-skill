# TouchEvent API 变化指南

## 背景

在较新的 HarmonyOS SDK 版本中，`TouchEvent` 的 API 发生了变化，某些属性和用法不再兼容。

## 常见错误

### 1. touchPoint 属性不存在

```typescript
// 错误 - touchPoint 不存在
const touchPoint = event.touchPoint;
```

### 2. pressure 属性类型问题

```typescript
// 错误 - pressure 可能为 undefined
this.currentPressure = event.touchPoint.pressure;
```

### 3. SourceTool 枚举不存在

```typescript
// 错误 - SourceTool.Pen 不存在
if (event.sourceTool === SourceTool.Pen)
```

### 4. tiltX/tiltY 属性不存在

```typescript
// 错误 - tiltX/tiltY 不存在
this.tiltX = event.touchPoint.tiltX;
```

## 解决方案

### 使用 event.touches 替代 touchPoint

```typescript
private handleTouch(event: TouchEvent) {
  const touchPoints = event.touches;
  if (touchPoints && touchPoints.length > 0) {
    const touchPoint = touchPoints[0];
    // 使用 touchPoint
  }
}
```

### SourceType 枚举

```typescript
// 使用字符串比较
const source = event.source;
if (source === 'pen') {
  // 手写笔
} else if (source === 'touch') {
  // 手指
}
```

## 详细代码示例

请参考 [TouchEventAPIDemo.ets](../assets/TouchEventAPIDemo.ets)

## 相关 API

- [TouchEvent](https://developer.harmonyos.com/cn/docs/documentation/doc-references/arkts-uievent-0000001773949446)
- [SourceTool](https://developer.harmonyos.com/cn/docs/documentation/doc-references/arkts-ivitycomponent-0000001774129442)
