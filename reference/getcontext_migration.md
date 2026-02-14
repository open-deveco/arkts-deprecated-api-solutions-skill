# getContext 弃用迁移指南

## 问题描述

`getContext(component?: Object): Context` API 已被弃用。

### 错误信息

```
"The signature '(component?: Object): Context' of 'getContext' is deprecated."
```

### 弃用原因

`getContext(this)` 是旧版 HarmonyOS API，在 ArkTS 中推荐使用更安全的 `getUIContext().getHostContext()` 方式获取上下文。

## 解决方案

### 在 Component 中使用

```typescript
// 旧写法 (已弃用)
let windowClass = await window.getLastWindow(getContext(this) as common.UIAbilityContext);

// 新写法
let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
let windowClass = await window.getLastWindow(context);
```

### 在普通类中使用

将 Context 作为参数传递：

```typescript
// 普通类中无法直接获取 UIContext，需要从 Component 传入 context
class WindowManager {
  async init(context: common.UIAbilityContext) {
    this.windowClass = await window.getLastWindow(context);
  }
}

// 在 Component 中调用
async aboutToAppear() {
  let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  await this.windowManager.init(context);
}
```

## 详细代码示例

- [GetContextReplacement.ets](../assets/GetContextReplacement.ets)

## 相关 API

| 旧 API | 新 API |
|--------|--------|
| `getContext(this)` | `this.getUIContext().getHostContext()` |

## 注意事项

1. `getUIContext()` 只能在 `@Component` 中使用
2. 普通类需要将 `UIAbilityContext` 作为参数传入
3. 需要导入 `import { common } from '@kit.AbilityKit'`
