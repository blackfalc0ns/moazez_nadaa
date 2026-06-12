import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:crypto/crypto.dart';
import 'dart:developer' as developer;

/// Certificate Pinning for enhanced security
/// 
/// Enterprise-level security for:
/// - Banking apps
/// - Fintech
/// - Healthcare
/// - Any app handling sensitive data
/// 
/// Prevents Man-in-the-Middle (MITM) attacks
class CertificatePinning {
  /// Setup certificate pinning for Dio
  static void setupCertificatePinning(
    Dio dio, {
    required List<String> allowedSHA256Fingerprints,
    bool allowBadCertificates = false,
  }) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      // Configure security context
      client.badCertificateCallback = (cert, host, port) {
        if (allowBadCertificates) {
          developer.log(
            '⚠️ WARNING: Allowing bad certificates (dev mode)',
            name: 'CertificatePinning',
          );
          return true;
        }

        // Get certificate SHA256 fingerprint
        final certSHA256 = _getCertificateSHA256(cert);

        developer.log(
          '🔐 Checking certificate for $host:$port',
          name: 'CertificatePinning',
        );
        developer.log(
          '📋 Certificate SHA256: $certSHA256',
          name: 'CertificatePinning',
        );

        // Check if certificate is pinned
        final normalizedCert = _normalizeFingerprint(certSHA256);
        final isPinned = allowedSHA256Fingerprints.any(
          (fingerprint) => _normalizeFingerprint(fingerprint) == normalizedCert,
        );

        if (isPinned) {
          developer.log(
            '✅ Certificate pinning validated',
            name: 'CertificatePinning',
          );
        } else {
          developer.log(
            '❌ Certificate pinning failed - MITM attack possible!',
            name: 'CertificatePinning',
            error: 'Certificate not in pinned list',
          );
        }

        return isPinned;
      };

      return client;
    };
  }

  /// Get SHA256 fingerprint from certificate
  static String _getCertificateSHA256(X509Certificate cert) {
    // Convert DER to SHA256
    final der = cert.der;
    final sha256 = _sha256Hash(der);
    return sha256;
  }

  /// Calculate SHA256 hash
  static String _sha256Hash(List<int> data) {
    final digest = sha256.convert(data).bytes;
    return digest
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(':')
        .toUpperCase();
  }

  static String _normalizeFingerprint(String fingerprint) {
    return fingerprint.trim().toUpperCase();
  }

  /// Get certificate fingerprint from server (for development)
  /// Use this to get the fingerprint to pin
  static Future<String?> getCertificateFingerprint(String url) async {
    try {
      final uri = Uri.parse(url);
      final socket = await SecureSocket.connect(
        uri.host,
        uri.port,
        onBadCertificate: (cert) {
          developer.log(
            '📋 Certificate SHA256: ${_getCertificateSHA256(cert)}',
            name: 'CertificatePinning',
          );
          return true;
        },
      );

      final cert = socket.peerCertificate;
      if (cert != null) {
        return _getCertificateSHA256(cert);
      }

      await socket.close();
      return null;
    } catch (e) {
      developer.log(
        '❌ Error getting certificate: $e',
        name: 'CertificatePinning',
      );
      return null;
    }
  }
}

/// Certificate pinning configuration
class CertificatePinningConfig {
  /// Production certificates (SHA256 fingerprints)
  static const List<String> productionCertificates = [
    '47:E8:5B:BA:A3:F9:88:82:EA:AD:BB:4E:39:84:2C:73:75:E1:8C:FB:BC:13:0F:A5:36:F2:F9:13:DF:05:C5:55',
  ];

  /// Staging certificates (SHA256 fingerprints)
  static const List<String> stagingCertificates = [
    // Add your staging certificate SHA256 fingerprints here
  ];

  /// Development certificates (SHA256 fingerprints)
  static const List<String> developmentCertificates = [
    // Add your development certificate SHA256 fingerprints here
  ];

  /// Get certificates for current environment
  static List<String> getCertificatesForEnvironment(String environment) {
    switch (environment.toLowerCase()) {
      case 'production':
        return productionCertificates;
      case 'staging':
        return stagingCertificates;
      case 'development':
        return developmentCertificates;
      default:
        return [];
    }
  }
}

/// Extension for easy certificate pinning setup
extension CertificatePinningExtension on Dio {
  /// Setup certificate pinning
  void setupCertificatePinning({
    required List<String> allowedFingerprints,
    bool allowBadCertificates = false,
  }) {
    CertificatePinning.setupCertificatePinning(
      this,
      allowedSHA256Fingerprints: allowedFingerprints,
      allowBadCertificates: allowBadCertificates,
    );
  }
}
