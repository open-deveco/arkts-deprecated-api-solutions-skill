# TransitionEffect API 迁移指南

## 问题描述

在 HarmonyOS API 12+ 中，组件的 `transition` 属性使用方式发生了变化。AI 经常生成错误的 API 调用方式。

## 错误代码

```typescript
// ❌ AI 经常生成的错误代码
.transition(TransitionEffect.OPACITY.transition(TransitionEdge.START))
```

**错误信息：**
```
Property 'transition' does not exist on type 'TransitionEffect<"opacity", number>'.
```

## 原因分析

`TransitionEffect` 没有 `transition()` 方法。在 API 12+ 中，过渡效果的使用方式发生了改变。

## 解决方案

### 正确代码

```typescript
// ✅ 正确的代码
.transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
```

### TransitionEffect 可用方法

| 方法 | 说明 |
|------|------|
| `opacity(value: number)` | 设置透明度过渡 |
| `translate(options: TranslateOptions)` | 设置平移过渡 |
| `scale(options: ScaleOptions)` | 设置缩放过渡 |
| `rotate(options: RotateOptions)` | 设置旋转过渡 |
| `move(edge: TransitionEdge)` | 设置滑动过渡 |
| `asymmetric(appear, disappear)` | 设置非对称过渡 |
| `combine(effect: TransitionEffect)` | 组合过渡效果 |
| `animation(params: AnimateParam)` | 设置动画参数 |

### 静态成员变量

| 成员 | 说明 |
|------|------|
| `IDENTITY` | 禁用过渡效果 |
| `OPACITY` | 透明度过渡 (0 到 1) |
| `SLIDE` | 滑动过渡 |
| `SLIDE_SWITCH` | 带缩放的滑动过渡 |

## 简单示例

```typescript
@Entry
@Component
struct TransitionExample {
  @State isExpanded: boolean = false;

  build() {
    Column() {
      Button('Toggle')
        .onClick(() => {
          this.isExpanded = !this.isExpanded;
        })

      if (this.isExpanded) {
        Text('Expanded')
          .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
      } else {
        Text('Collapsed')
          .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
      }
    }
  }
}
```

## 详细代码示例

> [TransitionEffectReplacement.ets](../assets/TransitionEffectReplacement.ets) - 完整的 TransitionEffect API 使用示例

## 相关文档

- [动画迁移指南](./ui_context_migration.md) - animateTo API 迁移
- [HarmonyOS 官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-transition-animation)
