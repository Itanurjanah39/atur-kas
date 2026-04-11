import 'package:flutter/material.dart';

import '../../../shared/themes/app_colors.dart';

class KebijakanView extends StatelessWidget {
  const KebijakanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _PolicyHeaderCard(),
            SizedBox(height: 16),
            _PolicySectionCard(
              title: 'Kebijakan & Privasi',
              icon: Icons.privacy_tip_outlined,
              content:
                  'Aplikasi Atur Kas menyimpan data transaksi pengguna secara lokal pada perangkat untuk mendukung penggunaan offline. Data yang dicatat tidak dibagikan ke pihak ketiga. Pengguna bertanggung jawab menjaga keamanan perangkat masing-masing agar data tetap aman. Apabila di masa mendatang tersedia sinkronisasi cloud, isi kebijakan privasi dapat diperbarui sesuai pengembangan layanan.',
            ),
            SizedBox(height: 12),
            _PolicySectionCard(
              title: 'Syarat & Ketentuan',
              icon: Icons.description_outlined,
              content:
                  'Dengan menggunakan aplikasi ini, pengguna memahami bahwa seluruh data yang dimasukkan merupakan tanggung jawab pengguna sendiri. Aplikasi ini ditujukan untuk membantu pencatatan keuangan pribadi dan bukan merupakan layanan audit, perpajakan, atau nasihat keuangan profesional. Pengguna disarankan untuk memeriksa kembali keakuratan data sebelum digunakan sebagai referensi.',
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PolicyHeaderCard extends StatelessWidget {
  const _PolicyHeaderCard();

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
          Icon(Icons.verified_user_outlined, color: Colors.white, size: 36),
          SizedBox(height: 12),
          Text(
            'Kebijakan & Ketentuan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Informasi penting mengenai privasi data dan penggunaan aplikasi.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _PolicySectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _PolicySectionCard({
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
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
