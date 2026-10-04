import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/services/department_repository.dart';

void main() {
  group('DepartmentRepository Tests', () {
    final repo = DepartmentRepository();

    test('should contain 5 major departments with home first', () {
      expect(DepartmentRepository.departments.length, 5);
      expect(DepartmentRepository.departments.first['id'], 'home');
      final ids = DepartmentRepository.departments.map((d) => d['id']).toList();
      expect(ids, containsAll(['home', 'women', 'men', 'kids', 'accessory']));
    });

    test('should return valid department content for women', () {
      final content = repo.getContent('women');
      expect(content.departmentId, 'women');
      expect(content.slides.isNotEmpty, true);
      expect(content.promoBox.title, contains('WOMEN'));
      expect(content.lookbook.title.isNotEmpty, true);
    });

    test('should return valid department content for men', () {
      final content = repo.getContent('men');
      expect(content.departmentId, 'men');
      expect(content.slides.isNotEmpty, true);
      expect(content.promoBox.title, contains('MEN'));
    });

    test('should fallback to home if unknown department is passed', () {
      final content = repo.getContent('non_existent_department');
      expect(content.departmentId, 'home');
    });
  });
}
