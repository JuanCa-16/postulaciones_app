import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/historial.dart';
import 'package:postulaciones_app/models/modalidad.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/inicio.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Postulacion> postulaciones = [
    Postulacion(
      id: 151,
      nombreOferta: 'Software Engineer Intern',
      nombreEmpresa: 'Sezzle',
      url: '',
      paginaAplicacion: 'LinkedIn',
      modalidad: Modalidad.REMOTO,
      fecha: '2026-10-01T15:24:50.619488',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
      historial: [
        const Historial(
          campoActualizado: "Estado",
          valorAntiguo: "Aplicado",
          valorNuevo: "HV Vista",
          fechaActualizacion: "2026-09-30T14:13:43.707381",
        ),
        const Historial(
          campoActualizado: "Modalidad",
          valorAntiguo: "HIBRIDO",
          valorNuevo: "REMOTO",
          fechaActualizacion: "2026-09-30T14:13:43.679925",
        ),
        const Historial(
          campoActualizado: "Modalidad",
          valorAntiguo: "REMOTO",
          valorNuevo: "HIBRIDO",
          fechaActualizacion: "2026-09-30T14:13:35.804288",
        ),
        const Historial(
          campoActualizado: "Estado",
          valorAntiguo: "Aplicado",
          valorNuevo: "HV Vista",
          fechaActualizacion: "2026-09-30T14:13:43.707381",
        ),
        const Historial(
          campoActualizado: "Modalidad",
          valorAntiguo: "HIBRIDO",
          valorNuevo: "REMOTO",
          fechaActualizacion: "2026-09-30T14:13:43.679925",
        ),
        const Historial(
          campoActualizado: "Modalidad",
          valorAntiguo: "REMOTO",
          valorNuevo: "HIBRIDO",
          fechaActualizacion: "2026-09-30T14:13:35.804288",
        ),
      ],
    ),

    Postulacion(
      id: 150,
      nombreOferta: 'Python Developer (Junior) - Remote Work',
      nombreEmpresa: 'INDI Staffing Services',
      url: '',
      paginaAplicacion: 'LinkedIn',
      modalidad: Modalidad.REMOTO,
      fecha: '2026-10-01T15:20:23.922354',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),

    Postulacion(
      id: 149,
      nombreOferta: 'Developer',
      nombreEmpresa: 'topaz',
      url: '',
      paginaAplicacion: 'Indeed',
      modalidad: Modalidad.HIBRIDO,
      fecha: '2026-09-30T14:53:07.243758',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),

    Postulacion(
      id: 148,
      nombreOferta: 'Desarrollador Full Stack Junior',
      nombreEmpresa: 'VIANCO TE TRANSPORTA SAS',
      url: '',
      paginaAplicacion: 'Indeed',
      modalidad: Modalidad.PRESENCIAL,
      fecha: '2026-09-30T14:41:45.072204',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),

    Postulacion(
      id: 147,
      nombreOferta:
          'Desarrollador Backend Java - Nodejs - JavaScript / Hibrido Bogotá',
      nombreEmpresa: 'Stefanini LATAM',
      url: '',
      paginaAplicacion: 'LinkedIn',
      modalidad: Modalidad.HIBRIDO,
      fecha: '2026-09-30T14:32:52.307521',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),

    Postulacion(
      id: 146,
      nombreOferta: 'Software Development Engineer',
      nombreEmpresa: 'Amadeus',
      url: 'https://amadeus.wd502.myworkdayjobs.com/en-US/jobs/userHome',
      paginaAplicacion: 'LinkedIn',
      modalidad: Modalidad.HIBRIDO,
      fecha: '2026-09-30T14:27:46.505574',
      estado: Estado(
        id: 3,
        nombre: 'Rechazado',
        color: '#EF4444',
        porDefecto: false,
      ),
    ),

    Postulacion(
      id: 145,
      nombreOferta: 'Desarrollador(a) Junior',
      nombreEmpresa: 'Cymetria Group S.A.S.',
      url: '',
      paginaAplicacion: 'Computrabajo',
      modalidad: Modalidad.HIBRIDO,
      fecha: '2026-09-30T14:04:58.202843',
      estado: Estado(
        id: 3,
        nombre: 'Rechazado',
        color: '#EF4444',
        porDefecto: false,
      ),
    ),

    Postulacion(
      id: 144,
      nombreOferta: 'Desarrollador Junior Java Fullstack IA . Remoto',
      nombreEmpresa: 'Mainsoft LTDA',
      url: '',
      paginaAplicacion: 'Computrabajo',
      modalidad: Modalidad.REMOTO,
      fecha: '2026-09-30T13:58:35.503249',
      estado: Estado(
        id: 5,
        nombre: 'HV Vista',
        color: '#b93de6',
        porDefecto: false,
      ),
    ),

    Postulacion(
      id: 143,
      nombreOferta:
          'Ingeniero/a de Software Backend de Experiencias Back TI (Junior) (64483)',
      nombreEmpresa: 'Bancolombia',
      url: 'https://empleo.grupobancolombia.com/bancolombia',
      paginaAplicacion: 'Bancolombia',
      modalidad: Modalidad.REMOTO,
      fecha: '2026-09-25T19:46:18.527734',
      estado: Estado(
        id: 3,
        nombre: 'Rechazado',
        color: '#EF4444',
        porDefecto: false,
      ),
    ),

    Postulacion(
      id: 142,
      nombreOferta: 'Junior Software Developer (Integrations)',
      nombreEmpresa: 'Proximus',
      url: '',
      paginaAplicacion: 'Indeed',
      modalidad: Modalidad.PRESENCIAL,
      fecha: '2026-09-25T19:36:16.924251',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),

    Postulacion(
      id: 141,
      nombreOferta: 'PepsiCo Next Gen 2027 | ANDINOS',
      nombreEmpresa: '',
      url: 'https://candidate.atsglobe.com/#/dashboard',
      paginaAplicacion: '',
      modalidad: Modalidad.REMOTO,
      fecha: '2026-09-24T15:23:14.88268',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),

    Postulacion(
      id: 140,
      nombreOferta: 'Junior Software Engineer (Colombia)',
      nombreEmpresa: 'Sezzle',
      url:
          'https://job-boards.greenhouse.io/sezzle/jobs/6110238003?gh_src=6d383ce23us',
      paginaAplicacion: 'LinkedIn',
      modalidad: Modalidad.REMOTO,
      fecha: '2026-09-24T14:41:12.584628',
      estado: Estado(
        id: 3,
        nombre: 'Rechazado',
        color: '#EF4444',
        porDefecto: false,
      ),
    ),

    Postulacion(
      id: 139,
      nombreOferta: 'Desarrollador de software',
      nombreEmpresa: 'Empresa confidencial',
      url: '',
      paginaAplicacion: 'Elempleo',
      modalidad: Modalidad.HIBRIDO,
      fecha: '2026-09-23T15:31:45.649142',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),

    Postulacion(
      id: 138,
      nombreOferta:
          'Estudiante o Profesional sistemas afines cargo Jr. Full Stack Developer o Desarrollador Full Stack',
      nombreEmpresa: 'Importante empresa del sector',
      url: '',
      paginaAplicacion: 'LinkedIn',
      modalidad: Modalidad.PRESENCIAL,
      fecha: '2026-09-23T15:17:30.953898',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),

    Postulacion(
      id: 137,
      nombreOferta: 'Desarrollador Full Stack Junior',
      nombreEmpresa: 'Grupo emi S.A.S',
      url: '',
      paginaAplicacion: 'Computrabajo',
      modalidad: Modalidad.HIBRIDO,
      fecha: '2026-09-23T15:14:59.996752',
      estado: Estado(
        id: 1,
        nombre: 'Aplicado',
        color: '#3B82F6',
        porDefecto: true,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          labelMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.buttonSecondary,
            padding: const EdgeInsets.symmetric(vertical: 10),
            side: const BorderSide(color: AppColors.buttonSecondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: Scaffold(
        body: SafeArea(child: Inicio(postulaciones: postulaciones)),
      ),
    );
  }
}
