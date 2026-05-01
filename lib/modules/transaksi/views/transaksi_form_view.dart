import 'package:atur_kas/shared/utils/currency_input_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shared/themes/app_colors.dart';
import '../../../shared/utils/date_helper.dart';
import '../controllers/transaksi_form_controller.dart';

class TransaksiFormView extends GetView<TransaksiFormController> {
  const TransaksiFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransaksiFormController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.black,
            centerTitle: false,
            title: Obx(
              () => Text(
                controller.pageTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: controller.formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  const _FormLabel('Keterangan'),
                  const SizedBox(height: 8),
                  _TextInput(
                    controller: controller.keteranganController,
                    hintText: 'Masukkan keterangan',
                    validator: controller.validateKeterangan,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  const _FormLabel('Tipe transaksi'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _DropdownInput<String>(
                      value: controller.selectedTipe.value,
                      hintText: 'Pilih tipe transaksi',
                      items: controller.tipeOptions.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['value'],
                          child: Text(
                            item['label']!,
                            style: TextStyle(
                              fontWeight:
                                  controller.selectedTipe.value == item['value']
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setTipe(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  const _FormLabel('Kategori'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _DropdownInput<String>(
                      value: controller.selectedKategori.value,
                      hintText: 'Pilih kategori',
                      items: controller.kategoriOptions.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontWeight:
                                  controller.selectedKategori.value == item
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => controller.setKategori(value),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const _FormLabel('Tanggal'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _DateInput(
                      text: DateHelper.formatTanggal(
                        controller.selectedTanggal.value,
                      ),
                      onTap: () => controller.pickTanggal(context),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const _FormLabel('Nominal'),
                  const SizedBox(height: 8),
                  _TextInput(
                    controller: controller.nominalController,
                    hintText: 'Masukkan nominal',
                    validator: controller.validateNominal,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [CurrencyInputFormatter()],
                  ),
                  const SizedBox(height: 28),

                  SizedBox(
                    height: 52,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isSubmitting.value
                            ? null
                            : controller.confirmSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: controller.isSubmitting.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                controller.submitLabel,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;

  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
    );
  }
}

class _TextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const _TextInput({
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  void _onChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(
        fontWeight: widget.controller.text.isNotEmpty
            ? FontWeight.w700
            : FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: AppColors.formBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _DropdownInput<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownInput({
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.formBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hintText, style: const TextStyle(color: AppColors.grey)),
          borderRadius: BorderRadius.circular(14),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DateInput extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _DateInput({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.formBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
