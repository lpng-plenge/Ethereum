// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

/**
 * @title Faucet
 * @notice Faucet de ejemplo para lección uno de Ethereum: permite a cualquiera retirar
 *         una pequeña cantidad de Ether por llamada (retirando por Wei faucet).
 * @dev    Versión de Solidity 0.6.10. No mantiene saldos por usuario ni límites de frecuencia.
 */
contract Faucet {
    /**
     * @notice Recibe depósitos de Ether al contrato inteligente.
     * @dev    Se ejecuta cuando la transacción no incluye datos o no coincide con ninguna función.
     *         No emite eventos ni aplica lógica adicional.
     */
    receive() external payable { }

    /**
     * @notice Retira una cantidad de Ether del contrato hacia el remitente.
     * @dev    Límite máximo por llamada: 0.1 ETH (100000000000000000 wei).
     *         Usa `transfer`, que reenvía ~2300 gas y revierte en caso de fallo.
     * @param  withdrawAmount Monto en wei a retirar (debe ser <= 0.1 ether).
     */
    function withdraw(uint withdrawAmount) public {
        // Requiere que la cantidad solicitada sea como máximo 0.1 ETH
        require(withdrawAmount <= 100000000000000000, "Exceeds per-call limit (0.1 ETH)");

        // Transfiere el Ether al remitente (revierte si el contrato no tiene saldo suficiente
        // o si el receptor es un contrato cuyo fallback/receive consume mas de ~2300 gas).
        msg.sender.transfer(withdrawAmount);
    }
}
