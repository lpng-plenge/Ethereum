# Faucet 

Pequeño **faucet** que permite recrear al recibir tokens de Google Faucet, tanto enviar y retirar hasta **0.1 ETH por llamada**. Ideal para practicar compilación, despliegue y llamadas de contrato en **Remix IDE**.

## Archivo

Archivo [[Faucet.sol](faucet/Faucet.sol)] en `Solidity 0.6.10)`

---

## Requisitos

* **Remix IDE** ([https://remix.ethereum.org](https://remix.ethereum.org))
* **MetaMask** con una red de pruebas (ejemplo **Sepolia**) y algo de Tokens de Sepolia en [cloud.google.com](https://cloud.google.com/application/web3/faucet) para desplegar en la VM de Remix.

> ⚠️ Este contrato usa **Solidity 0.6.10**. En Remix selecciona exactamente esa versión antes de compilar.

---

##  Pasos en Remix

### 1) Crear el archivo

1. Abre [https://remix.ethereum.org](https://remix.ethereum.org)
2. En el panel **File Explorers** → **Create New File** → nómbralo `Faucet.sol`.
3. Pega el código del contrato (arriba).

### 2) Compilar

1. Ve a **Solidity Compiler** (icono del compilador).
2. **Version:** selecciona `0.6.10` (no `0.8.x`).
3. (Opcional) Marca **Auto compile**.
4. Clic en **Compile Faucet.sol**.

### 3) Desplegar

Ve a **Deploy & Run Transactions** (icono “play”):

* **ENVIRONMENT**

    * **JavaScript VM** (rápido para pruebas locales), o
    * **Injected Provider – MetaMask** si quieres usar una testnet (p. ej., Sepolia).
* **CONTRACT:** `Faucet – Faucet.sol`
* Clic **Deploy** y confirma.

> Guarda la **dirección del contrato** (aparece en “Deployed Contracts”).

---

## Depositar ETH en el contrato (probar `receive()`)

Tienes dos formas sencillas:

**A) Desde Remix (low-level “transact”)**

1. En **Deploy & Run**, pon un valor en **Value** (arriba). Ej.: `0.01 ether`.
2. En la sección **Deployed Contracts**, despliega tu `Faucet`.
3. Usa el botón **transact** (o **receive** si aparece) para enviar ese valor al contrato.

    * Esto dispara la función `receive()` y deposita ETH en el contrato.

**B) Desde MetaMask**

1. Asegurate estar en la red de pruebas (p. ej., Sepolia).
2. Copia la **dirección del contrato**.
2. En MetaMask, envía una transferencia simple al contrato con el monto deseado (sin datos).

    * También ejecuta `receive()` y deposita fondos.

> Verifica el **balance** del contrato (en Remix, el botón `At Address` → `Low level interactions` o usando un “balance checker” aparte).

---

## Retirar (probar `withdraw(uint)`)

1. Asegúrate de que el contrato tenga fondos suficientes.
2. En **Deployed Contracts** → tu `Faucet`, ubica **withdraw**.
3. Ingresa el monto en **wei** (no en ether).

    * Ejemplo 0.1 ETH = `100000000000000000` wei.
4. Clic **transact** y confirma.
5. Revisa el balance de la cuenta (aumenta) y el del contrato (disminuye).

> 📏 **Límite:** la llamada revierte si pides **más de 0.1 ETH** o si el contrato **no tiene saldo** suficiente.

---

## Guias de prueba

* **Unidades:** `1 ether = 1e18 wei`.
* En Remix, el campo **Value** acepta `N ether` (p. ej., `0.05 ether`) al enviar fondos al contrato.
* El campo de la función `withdraw` **solo acepta wei** (usa la cifra completa).

---

## Problemas comunes

* **`revert Exceeds per-call limit (0.1 ETH)`**
  Estás intentando retirar más de 0.1 ETH. Baja la cantidad.
* **`revert` sin mensaje al retirar**
  Usualmente **saldo insuficiente** en el contrato. Depósitale primero.
* **Error con `transfer` al enviar a contratos**
  `transfer` solo reenvía \~2300 gas. Si el receptor es un **contrato** con lógica costosa en su `receive/fallback`, puede fallar. (Para didáctico está bien; en producción evalúa `call{value: ...}("")` + guardas anti-reentrancia.)

---

## Notas de seguridad (si lo extiendes)

* **Rate limiting:** agrega cooldown por dirección (`mapping(address => uint) lastClaim`) y límites diarios.
* **Constantes legibles:** usa `uint256 constant MAX_WITHDRAW = 0.1 ether;`.
* **Eventos:** emite `Deposit(address,uint256)` y `Withdrawal(address,uint256)`.
* **Reentrancia:** si migras de `transfer` a `call`, aplica **checks-effects-interactions** y/o `ReentrancyGuard`.
* **Propiedad:** si quieres pausar el faucet, añade `Ownable`/`onlyOwner`.

---

## Licencia

Este proyecto se distribuye bajo la licencia [MIT LICENSE](../LICENSE).

---

## FAQ

**¿Puedo usar Solidity 0.8.x?**
Sí, pero tendrías que **actualizar la versión** en el pragma y revisar diferencias (por ejemplo, `transfer` se mantiene, pero te conviene evaluar buenas prácticas actuales) Considera utilizar owneres, address y payable.

**¿Cómo veo el balance del contrato?**
En Remix, usa el panel de la cuenta (si estás en la VM) o una herramienta externa (block explorer en testnet) con la dirección del contrato.

---
