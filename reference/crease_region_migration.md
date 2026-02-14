# 折叠屏折痕区域 API 迁移指南

## 问题描述

在 HarmonyOS 开发折叠屏应用时，AI 经常生成错误的 API 调用方式来获取折痕区域信息。

## 错误代码

```typescript
// ❌ AI 经常生成的错误代码
const creaseRegion = display.getCurrentFoldCreaseRegion();
const rect = creaseRegion.rects[0];  // 错误：rects 不存在
const isVertical = creaseRegion.orientation === display.Orientation.VERTICAL;  // 错误：orientation 不存在
```

**错误信息：**
```
Property 'rects' does not exist on type 'FoldCreaseRegion'.
Property 'orientation' does not exist on type 'FoldCreaseRegion'.
```

## 解决方案

### 正确代码

```typescript
// ✅ 正确的代码
const creaseRegion = display.getCurrentFoldCreaseRegion();
if (creaseRegion && creaseRegion.creaseRects && creaseRegion.creaseRects.length > 0) {
  const rect = creaseRegion.creaseRects[0];
  // 使用 rect.width, rect.height, rect.top, rect.left
}

// 判断竖屏使用 width < height
const displayObj = display.getDefaultDisplaySync();
const isVertical = displayObj.width < displayObj.height;
```

### 关键点

1. **使用 `creaseRects` 而不是 `rects`** - API 返回的对象属性名是 `creaseRects`
2. **使用宽高比判断竖屏** - `FoldCreaseRegion` 没有 `orientation` 属性
3. **使用接口类型** - ArkTS 不支持直接使用 `display.Rect` 类型，需要自定义接口

## 简单示例

```typescript
interface CreaseRect {
  width: number;
  height: number;
  top: number;
  left: number;
}

@Component
struct CreaseExample {
  @State creaseArea: CreaseRect | null = null;

  aboutToAppear() {
    display.on('foldStatusChange', () => {
      this.updateCreaseInfo();
    });
    this.updateCreaseInfo();
  }

  private updateCreaseInfo() {
    const creaseRegion = display.getCurrentFoldCreaseRegion();
    if (creaseRegion && creaseRegion.creaseRects && creaseRegion.creaseRects.length > 0) {
      const rect = creaseRegion.creaseRects[0];
      this.creaseArea = {
        width: rect.width,
        height: rect.height,
        top: rect.top,
        left: rect.left
      };
    } else {
      this.creaseArea = null;
    }
  }

  build() {
    // UI 代码
  }
}
```

## 详细代码示例

> [CreaseRegionReplacement.ets](../assets/CreaseRegionReplacement.ets) - 完整的折痕区域 API 使用示例

## 相关文档

- [折叠状态监听](./system_migration.md)
- [HarmonyOS 官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-display#displaygetcurrentfoldcreaseregion10)
