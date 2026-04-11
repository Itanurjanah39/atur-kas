import 'package:flutter/material.dart';

import '../../../shared/themes/app_colors.dart';

class InfoAppView extends StatelessWidget {
  const InfoAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Aplikasi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HeaderCard(),
          SizedBox(height: 16),
          _SectionCard(
            title: 'Informasi Umum',
            icon: Icons.apps_rounded,
            content:
                'Atur Kas adalah aplikasi pencatatan keuangan sederhana untuk membantu pengguna mencatat pemasukan, pengeluaran, dan memantau saldo secara lebih rapi. Aplikasi ini dirancang untuk penggunaan personal dengan pengalaman yang ringan, cepat, dan mudah dipahami.',
          ),
          SizedBox(height: 12),
          _SectionCard(
            title: 'Syarat & Ketentuan',
            icon: Icons.description_outlined,
            content:
                'Dengan menggunakan aplikasi ini, pengguna memahami bahwa seluruh data transaksi yang dimasukkan merupakan tanggung jawab pengguna sendiri. Aplikasi ini disediakan untuk membantu pencatatan keuangan dan tidak dimaksudkan sebagai layanan audit, perpajakan, atau nasihat finansial profesional. Pengguna bertanggung jawab untuk memeriksa kembali keakuratan data yang diinput.',
          ),
          SizedBox(height: 12),
          _SectionCard(
            title: 'Kebijakan & Privasi',
            icon: Icons.privacy_tip_outlined,
            content:
                'Data yang dicatat pada aplikasi ini disimpan secara lokal pada perangkat pengguna selama menggunakan mode offline. Aplikasi tidak membagikan data transaksi pengguna ke pihak ketiga. Pengguna disarankan menjaga keamanan perangkat masing-masing agar data tetap aman. Jika di kemudian hari aplikasi menambahkan sinkronisasi cloud, kebijakan privasi dapat diperbarui sesuai kebutuhan layanan tersebut.',
          ),
          SizedBox(height: 12),
          _SectionCard(
            title: 'Versi Aplikasi',
            icon: Icons.system_update_alt_outlined,
            content:
                'Versi saat ini: 1.0.0\n\nAplikasi ini masih dalam tahap pengembangan awal dan akan terus diperbarui untuk meningkatkan fitur, stabilitas, dan kenyamanan penggunaan.',
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            'Atur Kas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Catat keuangan dengan lebih sederhana, rapi, dan praktis.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.accent,
                child: Icon(icon, color: AppColors.black),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
