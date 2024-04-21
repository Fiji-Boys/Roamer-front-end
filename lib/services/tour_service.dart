import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';

class TourService {
  List<Tour> getAll() {
    List<Tour> tours = [];

    List<KeyPoint> starterTourKeyPoints = [
      KeyPoint(
        id: 1,
        name: "Petrovaradin Fortress",
        description:
            "Petrovaradin Fortress nicknamed Gibraltar on/of the Danube, is a fortress in the town of Petrovaradin.",
        images: [
          "https://www.creativehistorybalkans.com/wp-content/uploads/2019/05/Novi_Sad_00_web_feat.jpg",
          "https://nsuzivo.rs/wp-content/uploads/2021/10/Petrovaradinska_tvrdjava_2.jpg"
        ],
        latitude: 45.25214653312344,
        longitude: 19.865811402657357,
      ),
      KeyPoint(
        id: 2,
        name: "Dunavski Park",
        description:
            "Danube Park or Dunavski Park is an urban park in the downtown of Novi Sad formed in 1895.",
        images: [
          "https://live.staticflickr.com/695/20996605404_dd50a482a7_b.jpg",
          "https://www.shutterstock.com/image-photo/novi-sad-serbia-october-29-600nw-2071913192.jpg"
        ],
        latitude: 45.25529047021965,
        longitude: 19.851207525802778,
      ),
      KeyPoint(
        id: 3,
        name: "The Statue of Jovan Jovanovic Zmaj",
        description:
            "The monument is built of bronze and is 230 centimeters high. The work is the work of sculptor Dragan Nikolić from Belgrade.",
        images: [
          "https://live.staticflickr.com/3835/14254427657_96a8d0b8fc_b.jpg"
        ],
        latitude: 45.25689538552521,
        longitude: 19.847889666499356,
      ),
      KeyPoint(
        id: 4,
        name: "Name of Mary Church",
        description:
            "Roman Catholic parish church dedicated to the feast of the Holy Name of Mary.",
        images: [
          "https://novisad.travel/wp-content/uploads/2019/01/crkva-Imena-Marijinog-23_compressed.jpg",
          "https://visitdistrikt.rs/media/2021/04/Visit-NS-Trg-slobode-foto-Jelena-Ivanovic-26-scaled.jpg"
        ],
        latitude: 45.255399209538496,
        longitude: 19.845446657629196,
      ),
    ];

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
    Tour starterTour = Tour(
        name: "Starter tour",
        description: "Explore Novi Sad",
        keyPoints: starterTourKeyPoints,
        type: TourType.informational);
    tours.add(newTour);
    tours.add(newTour2);
    tours.add(newTour3);
    tours.add(newTour4);
    tours.add(starterTour);

    return tours;
  }
}
