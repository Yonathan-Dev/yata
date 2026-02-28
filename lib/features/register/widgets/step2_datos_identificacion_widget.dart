import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/app_exports.dart';

class Step2DatosIdentificacionWidget extends ConsumerStatefulWidget {
  final int currentStep;
  final void Function(int)? onStepChanged;
  const Step2DatosIdentificacionWidget({
    super.key,
    required this.currentStep,
    this.onStepChanged,
  });

  @override
  ConsumerState<Step2DatosIdentificacionWidget> createState() =>
      _Step2DatosIdentificacionWidgetState();
}

class _Step2DatosIdentificacionWidgetState
    extends ConsumerState<Step2DatosIdentificacionWidget> {
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: Container(
        width: double.infinity,
        color: Tema.primaryColor,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Tema.blanco,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.contact_mail_rounded,
                  size: 50,
                  color: Tema.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              // Título
              Text(
                'Captura la foto de tu documento de\nidentidad del lado frontal',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Tema.blanco,
                ),
              ),
              const SizedBox(height: Constantes.separacion),
              // Subtítulo
              Text(
                'Te pediremos que uses la cámara para capturar\ntu documento de identidad',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Tema.blanco.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: Constantes.separacion * 2),
              // Lista de instrucciones
              _buildInstructionItemWhite(
                context,
                'Coloca el documento en una superficie plana y asegúrate de que esté completamente visible.',
              ),
              const SizedBox(height: 16),
              _buildInstructionItemWhite(
                context,
                'Tomar la foto real y actualizada',
              ),
              const SizedBox(height: 16),
              _buildInstructionItemWhite(
                context,
                'Mantén tu celular en posición vertical durante este proceso',
              ),
              const SizedBox(height: 24),
              // Aviso informativo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Tema.blanco,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Payment recopila imágenes para habilitar cuentas de dinero electrónico a través de validaciones digitales, con el fin de minimizar los riesgos de suplantación de identidad.',
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.negro,
                    fontSize: 8.0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Botón Comenzar
              SizedBox(
                width: double.infinity,
                height: Constantes.botonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? photo = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (photo != null) {
                      widget.onStepChanged?.call(widget.currentStep + 1);
                    }

                    ref
                        .read(registerProvider.notifier)
                        .setRutaImagen1(photo!.path);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Tema.negro,
                    foregroundColor: Tema.blanco,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Comenzar',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Tema.blanco,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItemWhite(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: Tema.blanco, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Tema.blanco.withValues(alpha: 0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
