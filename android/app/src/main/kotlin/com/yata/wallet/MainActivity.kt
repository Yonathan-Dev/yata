package com.yata.wallet

import io.flutter.embedding.android.FlutterFragmentActivity
import android.os.Bundle
import android.util.Log
import androidx.biometric.BiometricManager

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val biometricManager = BiometricManager.from(this)
        val canAuthenticate = biometricManager.canAuthenticate(
            BiometricManager.Authenticators.BIOMETRIC_STRONG
        )
        
        Log.d("BIOMETRIC_CHECK", "canAuthenticate result: $canAuthenticate")
        // 0 = SUCCESS
        // 1 = ERROR_HW_UNAVAILABLE
        // 2 = ERROR_NONE_ENROLLED
        // 3 = ERROR_NO_HARDWARE
        // 4 = ERROR_SECURITY_UPDATE_REQUIRED
        // 12 = ERROR_UNSUPPORTED
    }
}