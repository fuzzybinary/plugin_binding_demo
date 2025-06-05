package com.example.plugin_binding_demo

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor

class BluetoothGattCallbackProxy(val callback: CallbackInterface) : android.bluetooth.BluetoothGattCallback() {
    interface CallbackInterface {
        fun onConnectionStateChange(gatt: android.bluetooth.BluetoothGatt, status: Int, newState: Int)
        fun onServicesDiscovered(gatt: android.bluetooth.BluetoothGatt, status: Int)
        fun onPhyUpdate(gatt: BluetoothGatt?, txPhy: Int, rxPhy: Int, status: Int)
        fun onPhyRead(gatt: BluetoothGatt?, txPhy: Int, rxPhy: Int, status: Int)
        fun onCharacteristicRead(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            value: ByteArray,
            status: Int
        )
        fun onCharacteristicWrite(
            gatt: BluetoothGatt?,
            characteristic: BluetoothGattCharacteristic?,
            status: Int
        )
        fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            value: ByteArray
        )
        fun onDescriptorRead(
            gatt: BluetoothGatt,
            descriptor: BluetoothGattDescriptor,
            status: Int,
            value: ByteArray
        )
        fun onDescriptorWrite(
            gatt: BluetoothGatt?,
            descriptor: BluetoothGattDescriptor?,
            status: Int
        )
        fun onReliableWriteCompleted(gatt: BluetoothGatt?, status: Int)
        fun onReadRemoteRssi(gatt: BluetoothGatt?, rssi: Int, status: Int)
        fun onMtuChanged(gatt: BluetoothGatt?, mtu: Int, status: Int)
        fun onServiceChanged(gatt: BluetoothGatt)
    }

    override fun onPhyUpdate(gatt: BluetoothGatt?, txPhy: Int, rxPhy: Int, status: Int) {
        callback.onPhyUpdate(gatt, txPhy, rxPhy, status)
    }

    override fun onPhyRead(gatt: BluetoothGatt?, txPhy: Int, rxPhy: Int, status: Int) {
        callback.onPhyRead(gatt, txPhy, rxPhy, status)
    }


    override fun onConnectionStateChange(gatt: android.bluetooth.BluetoothGatt, status: Int, newState: Int) {
        callback.onConnectionStateChange(gatt, status, newState)
    }

    override fun onServicesDiscovered(gatt: android.bluetooth.BluetoothGatt, status: Int) {
        callback.onServicesDiscovered(gatt, status)
    }

    override fun onCharacteristicRead(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic,
        value: ByteArray,
        status: Int
    ) {
        callback.onCharacteristicRead(gatt, characteristic, value, status)
    }

    override fun onCharacteristicWrite(
        gatt: BluetoothGatt?,
        characteristic: BluetoothGattCharacteristic?,
        status: Int
    ) {
        callback.onCharacteristicWrite(gatt, characteristic, status)
    }

    override fun onCharacteristicChanged(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic,
        value: ByteArray
    ) {
        callback.onCharacteristicChanged(gatt, characteristic, value)
    }

    override fun onDescriptorRead(
        gatt: BluetoothGatt,
        descriptor: BluetoothGattDescriptor,
        status: Int,
        value: ByteArray
    ) {
        callback.onDescriptorRead(gatt, descriptor, status, value)
    }

    override fun onDescriptorWrite(
        gatt: BluetoothGatt?,
        descriptor: BluetoothGattDescriptor?,
        status: Int
    ) {
        callback.onDescriptorWrite(gatt, descriptor, status)
    }

    override fun onReliableWriteCompleted(gatt: BluetoothGatt?, status: Int) {
        callback.onReliableWriteCompleted(gatt, status)
    }

    override fun onReadRemoteRssi(gatt: BluetoothGatt?, rssi: Int, status: Int) {
        callback.onReadRemoteRssi(gatt, rssi, status)
    }

    override fun onMtuChanged(gatt: BluetoothGatt?, mtu: Int, status: Int) {
        callback.onMtuChanged(gatt, mtu, status)
    }

    override fun onServiceChanged(gatt: BluetoothGatt) {
        callback.onServiceChanged(gatt)
    }
}