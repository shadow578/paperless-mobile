import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_paperless_mobile/features/documents/bloc/documents_cubit.dart';
import 'package:flutter_paperless_mobile/features/documents/bloc/documents_state.dart';
import 'package:flutter_paperless_mobile/features/documents/model/document.model.dart';
import 'package:flutter_paperless_mobile/features/documents/model/document_filter.dart';
import 'package:flutter_paperless_mobile/features/documents/model/paged_search_result.dart';
import 'package:flutter_paperless_mobile/features/documents/repository/document_repository.dart';
import 'package:flutter_paperless_mobile/features/labels/correspondent/model/correspondent.model.dart';
import 'package:flutter_paperless_mobile/features/labels/document_type/model/document_type.model.dart';
import 'package:flutter_paperless_mobile/features/labels/tags/model/tag.model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../utils.dart';
@GenerateNiceMocks([MockSpec<DocumentRepository>()])
import 'document_cubit_test.mocks.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<DocumentModel> documents = List.unmodifiable(
    await loadCollection("test/fixtures/documents/documents.json", DocumentModel.fromJson),
  );
  final List<Tag> tags = List.unmodifiable(
    await loadCollection("test/fixtures/tags/tags.json", Tag.fromJson),
  );
  final List<Correspondent> correspondents = List.unmodifiable(
    await loadCollection(
        "test/fixtures/correspondents/correspondents.json", Correspondent.fromJson),
  );
  final List<DocumentType> documentTypes = List.unmodifiable(
    await loadCollection("test/fixtures/document_types/document_types.json", DocumentType.fromJson),
  );

  final MockDocumentRepository documentRepository = MockDocumentRepository();
  group("Test DocumentsCubit reloadDocuments", () {
    test("Assert correct initial state", () {
      expect(DocumentsCubit(documentRepository).state, DocumentsState.initial);
    });

    blocTest<DocumentsCubit, DocumentsState>(
      "Load documents shall emit new state containing the found documents",
      setUp: () => when(documentRepository.find(any)).thenAnswer(
        (_) async => PagedSearchResult(
          count: 10,
          next: null,
          previous: null,
          results: documents,
        ),
      ),
      build: () => DocumentsCubit(documentRepository),
      seed: () => DocumentsState.initial,
      act: (bloc) => bloc.loadDocuments(),
      expect: () => [
        DocumentsState(
            isLoaded: true,
            value: [
              PagedSearchResult(
                count: 10,
                next: null,
                previous: null,
                results: documents,
              ),
            ],
            filter: DocumentFilter.initial)
      ],
      verify: (bloc) => verify(documentRepository.find(any)).called(1),
    );

    blocTest<DocumentsCubit, DocumentsState>(
      "Reload documents shall emit new state containing the same documents as before",
      setUp: () => when(documentRepository.find(any)).thenAnswer(
        (_) async => PagedSearchResult(
          count: 10,
          next: null,
          previous: null,
          results: documents,
        ),
      ),
      build: () => DocumentsCubit(documentRepository),
      seed: () => DocumentsState.initial,
      act: (bloc) => bloc.loadDocuments(),
      expect: () => [
        DocumentsState(
            isLoaded: true,
            value: [
              PagedSearchResult(
                count: 10,
                next: null,
                previous: null,
                results: documents,
              ),
            ],
            filter: DocumentFilter.initial)
      ],
      verify: (bloc) => verify(documentRepository.find(any)).called(1),
    );
  });
}