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
    Tour starterTour = Tour(
        name: "Starter tour",
        description: "Explore Novi Sad",
        keyPoints: starterTourKeyPoints,
        type: TourType.informational);

    List<KeyPoint> kp1 = [
      KeyPoint(
          id: 1,
          name: "Trg Slobode",
          description:
              """Naša tura počinje na Trgu Slobode, središtu Novog Sada. Okružen impozantnim zgradama, trg je srce grada, mesto gde se Novosađani okupljaju i gde se održavaju brojni kulturni događaji.

Dok stojimo na Trgu Slobode, osluškujemo zvuke grada i osećamo puls Novog Sada, grada koji je centar kulture i zabave u Vojvodini.""",
          images: [
            "https://live.staticflickr.com/4874/32089154748_ec91ec81c9_b.jpg",
            "https://gradskeinfo.rs/wp-content/uploads/2021/11/Mileticev-trg-3-scaled.jpg"
          ],
          latitude: 45.255421,
          longitude: 19.845135),
      KeyPoint(
          id: 2,
          name: "Dunavski park",
          description:
              """Nastavljamo šetnju kroz Dunavski park, oazu zelenila usred grada. Park je omiljeno mesto Novosađana za šetnju, rekreaciju i opuštanje. Uživamo u miru i tišini, dok oko nas cveta raznovrsno cveće i šarenilo zelenila.

Dok prolazimo kroz Dunavski park, otkrivamo skriveni mir i lepotu koju pruža priroda usred gradskog života.""",
          images: [
            "https://live.staticflickr.com/695/20996605404_dd50a482a7_b.jpg",
            "https://www.kurir.rs/data/images/2023/12/02/20/3728170_shutterstock-2070491330_share.jpg"
          ],
          latitude: 45.255143,
          longitude: 19.850501),
      KeyPoint(
          id: 3,
          name: "Petrovaradinska tvrđava",
          description:
              """Naša sledeća stanica je Petrovaradinska tvrđava, simbol grada Novog Sada. Ova impozantna tvrđava pruža predivan pogled na grad i reku Dunav. Šetnja kroz tvrđavu pruža nam uvid u bogatu istoriju ovog grada.

Dok stojimo na tvrđavi, otkrivamo da Novi Sad nije samo grad, već mesto koje spaja prošlost i sadašnjost, sa spektakularnim pogledom na Dunav i okolne predele.""",
          images: [
            "https://www.creativehistorybalkans.com/wp-content/uploads/2019/05/Novi_Sad_00_web_feat.jpg",
            "https://nsuzivo.rs/wp-content/uploads/2021/10/Petrovaradinska_tvrdjava_2.jpg"
          ],
          latitude: 45.253467,
          longitude: 19.861225),
      KeyPoint(
          id: 4,
          name: "Dunavski kej",
          description:
              """Poslednja tačka naše ture je šetnja duž Dunavskog keja. Ovde uživamo u prelepom pogledu na reku Dunav i Frušku goru. Dunavski kej je omiljeno mesto Novosađana za šetnju i relaksaciju.

Dok šetamo Dunavskim kejom, osećamo duh slobode koji nosi Dunav, reka koja spaja gradove i ljude duž svog toka.""",
          images: [
            "https://www.novisad.rs/sites/default/files/imagecache/800xXXX/images/izabrana3.jpg",
            "https://live.staticflickr.com/3850/14563428482_c88aa107a4_b.jpg"
          ],
          latitude: 45.261341,
          longitude: 19.856201)
    ];
    Tour tour1 = Tour(
        name: "Tura kroz Novi Sad",
        description: "Šetnja kroz srce Vojvodine",
        keyPoints: kp1,
        type: TourType.informational);

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

    Tour newTour = Tour(
        name: "Put do kifli",
        description: "Najbrzi put do vrucih(mozda) kifli",
        keyPoints: keyPoints,
        type: TourType.secret);

    tours.add(tour1);
    tours.add(newTour);
    return tours;
  }
}
