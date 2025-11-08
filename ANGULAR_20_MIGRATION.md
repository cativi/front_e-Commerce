# Migración a Angular 20

Este documento describe la migración de Angular 17.2.0 a Angular 20.0.0.

## Cambios Realizados

### 1. Actualización de Dependencias

Se actualizaron las siguientes dependencias en `package.json`:

#### Dependencies
- `@angular/animations`: ^17.2.0 → ^20.0.0
- `@angular/common`: ^17.2.0 → ^20.0.0
- `@angular/compiler`: ^17.2.0 → ^20.0.0
- `@angular/core`: ^17.2.0 → ^20.0.0
- `@angular/forms`: ^17.2.0 → ^20.0.0
- `@angular/platform-browser`: ^17.2.0 → ^20.0.0
- `@angular/platform-browser-dynamic`: ^17.2.0 → ^20.0.0
- `@angular/router`: ^17.2.0 → ^20.0.0
- `zone.js`: ~0.14.3 → ~0.15.0

#### DevDependencies
- `@angular-devkit/build-angular`: ^17.2.2 → ^20.0.0
- `@angular/cli`: ^17.2.2 → ^20.0.0
- `@angular/compiler-cli`: ^17.2.0 → ^20.0.0
- `typescript`: ~5.3.2 → ~5.6.0

### 2. Requisitos del Sistema

**IMPORTANTE**: Angular 20 requiere Node.js versión **20.11.1 o superior**. Node.js v18 alcanzó su fin de vida el 27 de marzo de 2025 y ya no es compatible.

Verifica tu versión de Node.js:
```bash
node -v
```

Si necesitas actualizar Node.js, descarga la versión LTS más reciente desde [nodejs.org](https://nodejs.org/).

### 3. Instalación de Dependencias

Para instalar las nuevas dependencias, ejecuta:

```bash
# Eliminar dependencias antiguas
rm -rf node_modules package-lock.json

# Instalar nuevas dependencias
npm install
```

O con yarn:
```bash
rm -rf node_modules yarn.lock
yarn install
```

## Nuevas Características de Angular 20

### 1. APIs Estables
Las siguientes APIs se han graduado a estables en Angular 20:
- `effect()`
- `linkedSignal()`
- `toSignal()`
- Hidratación incremental
- Configuración de modo de renderizado a nivel de ruta

### 2. Detección de Cambios Sin Zone.js (Developer Preview)
La detección de cambios sin zone.js ha sido promovida a vista previa para desarrolladores. Si deseas habilitarla:

```typescript
import { provideZonelessChangeDetection } from '@angular/core';

bootstrapApplication(AppComponent, {
  providers: [provideZonelessChangeDetection()]
});
```

### 3. Template Hot Module Replacement (HMR)
El HMR para templates es ahora una característica predeterminada, permitiendo actualizaciones de UI casi instantáneas en el navegador sin recargas completas de página ni pérdida del estado de la aplicación.

### 4. Verificación de Tipos para Host Bindings
Angular 20 ahora valida cada expresión en los metadatos `host` de un componente o directiva, mejorando la detección de errores en tiempo de compilación.

### 5. Directivas Estructurales Deprecadas
Las directivas estructurales `*ngIf`, `*ngFor` y `*ngSwitch` están oficialmente deprecadas en favor de la sintaxis de control de flujo:

**Antes (deprecado):**
```html
<div *ngIf="condition">Content</div>
<div *ngFor="let item of items">{{ item }}</div>
```

**Ahora (recomendado):**
```html
@if (condition) {
  <div>Content</div>
}

@for (item of items; track item.id) {
  <div>{{ item }}</div>
}
```

**Nota:** La aplicación actual no utiliza estas directivas deprecadas, por lo que no se requieren cambios inmediatos en este aspecto.

## Siguientes Pasos

1. Asegúrate de tener Node.js 20.11.1 o superior instalado
2. Ejecuta `npm install` para instalar las nuevas dependencias
3. Ejecuta `npm start` para iniciar el servidor de desarrollo
4. Ejecuta `npm run build` para verificar que la compilación funcione correctamente
5. Ejecuta `npm test` para asegurarte de que todas las pruebas pasen

## Resolución de Problemas

Si encuentras problemas durante la migración:

1. **Errores de TypeScript**: Verifica que estás usando TypeScript 5.6.x
2. **Errores de compilación**: Limpia la caché de Angular:
   ```bash
   rm -rf .angular
   ```
3. **Errores de dependencias**: Intenta eliminar node_modules y reinstalar:
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

## Referencias

- [Anuncio oficial de Angular 20](https://blog.angular.dev/announcing-angular-v20-b5c9c06cf301)
- [Guía de actualización de Angular](https://update.angular.io/)
- [Documentación de Angular](https://angular.dev/)
