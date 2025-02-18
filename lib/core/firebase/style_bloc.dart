import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'firebase_service.dart';

class StyleBloc extends Bloc<StyleEvent, StyleState> {
  StyleBloc() : super(StyleInitial()) {
    on<FetchStyleEvent>((event, emit) async {
      // Use emit.forEach to listen to the stream and emit new states properly.
      await emit.forEach<DocumentSnapshot>(
        FirebaseService.getCardStyleStream(),
        onData: (documentSnapshot) {
          if (documentSnapshot.exists) {
            final data = documentSnapshot.data() as Map<String, dynamic>;
            return StyleLoaded(
              cardColor: data['cardColor'] ?? '#FFFFFF',
              textColor: data['textColor'] ?? '#000000',
              borderRadius: (data['borderRadius'] ?? 8).toDouble(),
              fontFamily: data['fontFamily'] ?? 'Roboto',
              fontSize: (data['fontSize'] ?? 16).toDouble(),
            );
          } else {
            return const StyleError('No style data found');
          }
        },
        onError: (_, __) => const StyleError('Error fetching styles'),
      );
    });
  }
}

abstract class StyleEvent extends Equatable {
  const StyleEvent();
  @override
  List<Object> get props => [];
}

class FetchStyleEvent extends StyleEvent {}

abstract class StyleState extends Equatable {
  const StyleState();
  @override
  List<Object?> get props => [];
}

class StyleInitial extends StyleState {}

class StyleLoaded extends StyleState {
  final String cardColor;
  final String textColor;
  final double borderRadius;
  final String fontFamily;
  final double fontSize;

  const StyleLoaded({
    required this.cardColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontFamily,
    required this.fontSize,
  });

  @override
  List<Object?> get props =>
      [cardColor, textColor, borderRadius, fontFamily, fontSize];
}

class StyleError extends StyleState {
  final String message;
  const StyleError(this.message);

  @override
  List<Object?> get props => [message];
}
