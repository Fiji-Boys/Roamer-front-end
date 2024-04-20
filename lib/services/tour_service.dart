import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';

class TourService {
  List<Tour> getAll() {
    List<Tour> tours = [];

    List<KeyPoint> keyPoints = [
      KeyPoint(
          id: 1,
          name: "Sima",
          description: "Description of Sima",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image2.jpg"
          ],
          latitude: 45.262501,
          longitude: 19.839263),
      KeyPoint(
          id: 2,
          name: "Vruce kifle",
          description: "Description of Vruce kifle",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.255452,
          longitude: 19.841251),
    ];
    List<KeyPoint> keyPoints2 = [
      KeyPoint(
          id: 3,
          name: "Univer",
          description: "Description of Univer",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image2.jpg"
          ],
          latitude: 45.253334,
          longitude: 19.844478),
      KeyPoint(
          id: 4,
          name: "Burgija",
          description: "Description of Burgija",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.239358,
          longitude: 19.850856),
    ];
    List<KeyPoint> keyPoints3 = [
      KeyPoint(
          id: 5,
          name: "NTP",
          description: "Description of NTP",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image2.jpg"
          ],
          latitude: 45.244923,
          longitude: 19.847757),
      KeyPoint(
          id: 6,
          name: "Turbo kruzni",
          description: "Description of Turbo",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.244777,
          longitude: 19.84679),
      KeyPoint(
          id: 7,
          name: "Tocionica",
          description: "Description of Turbo kruzni",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.24262,
          longitude: 19.846887),
      KeyPoint(
          id: 8,
          name: "Iza ugla",
          description: "Description of Tocionica",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.242733,
          longitude: 19.849508),
      KeyPoint(
          id: 9,
          name: "NTP opet",
          description: "Description of NTP opet",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.244368,
          longitude: 19.848467),
    ];

    List<KeyPoint> keyPoints4 = [
      KeyPoint(
          id: 5,
          name: "Sumnjivo dvoriste",
          description: "Setam samo sa osobama zenskog pola",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image2.jpg"
          ],
          latitude: 45.244085,
          longitude: 19.852904),
    ];

    Tour newTour = Tour(
        name: "Put do kifli",
        description: "Najbrzi put do vrucih(mozda) kifli",
        keyPoints: keyPoints,
        type: TourType.secret);
    Tour newTour2 = Tour(
        name: "Poseta burice",
        description: "Do mog dragog brata",
        keyPoints: keyPoints2,
        type: TourType.adventure);
    Tour newTour3 = Tour(
        name: "Setnja sa Luburom",
        description: "Sa nasim dragim profesorom",
        keyPoints: keyPoints3,
        type: TourType.adventure);
    Tour newTour4 = Tour(
        name: "Sumnjivo dvoriste na limanu",
        description: "Easter egg tura",
        keyPoints: keyPoints4,
        type: TourType.adventure);
    tours.add(newTour);
    tours.add(newTour2);
    tours.add(newTour3);
    tours.add(newTour4);

    return tours;
  }
}
