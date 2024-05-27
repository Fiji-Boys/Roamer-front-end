import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';

class TourService {
  List<Tour> getAll() {
    List<Tour> tours = [];

    // List<KeyPoint> starterTourKeyPoints = [
    //   KeyPoint(
    //     id: 1,
    //     name: "Petrovaradin Fortress",
    //     description:
    //         "Petrovaradin Fortress nicknamed Gibraltar on/of the Danube, is a fortress in the town of Petrovaradin.",
    //     images: [
    //       "https://www.creativehistorybalkans.com/wp-content/uploads/2019/05/Novi_Sad_00_web_feat.jpg",
    //       "https://nsuzivo.rs/wp-content/uploads/2021/10/Petrovaradinska_tvrdjava_2.jpg"
    //     ],
    //     latitude: 45.25214653312344,
    //     longitude: 19.865811402657357,
    //   ),
    //   KeyPoint(
    //     id: 2,
    //     name: "Dunavski Park",
    //     description:
    //         "Danube Park or Dunavski Park is an urban park in the downtown of Novi Sad formed in 1895.",
    //     images: [
    //       "https://live.staticflickr.com/695/20996605404_dd50a482a7_b.jpg",
    //       "https://www.shutterstock.com/image-photo/novi-sad-serbia-october-29-600nw-2071913192.jpg"
    //     ],
    //     latitude: 45.25529047021965,
    //     longitude: 19.851207525802778,
    //   ),
    //   KeyPoint(
    //     id: 3,
    //     name: "The Statue of Jovan Jovanovic Zmaj",
    //     description:
    //         "The monument is built of bronze and is 230 centimeters high. The work is the work of sculptor Dragan Nikolić from Belgrade.",
    //     images: [
    //       "https://live.staticflickr.com/3835/14254427657_96a8d0b8fc_b.jpg"
    //     ],
    //     latitude: 45.25689538552521,
    //     longitude: 19.847889666499356,
    //   ),
    //   KeyPoint(
    //     id: 4,
    //     name: "Name of Mary Church",
    //     description:
    //         "Roman Catholic parish church dedicated to the feast of the Holy Name of Mary.",
    //     images: [
    //       "https://novisad.travel/wp-content/uploads/2019/01/crkva-Imena-Marijinog-23_compressed.jpg",
    //       "https://visitdistrikt.rs/media/2021/04/Visit-NS-Trg-slobode-foto-Jelena-Ivanovic-26-scaled.jpg"
    //     ],
    //     latitude: 45.255399209538496,
    //     longitude: 19.845446657629196,
    //   ),
    // ];
    // Tour starterTour = Tour(
    //     name: "Starter tour",
    //     description: "Explore Novi Sad",
    //     keyPoints: starterTourKeyPoints,
    //     type: TourType.informational);

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

    Tour tour2 = Tour(
        name: "Put do kifli",
        description: "Najbrzi put do vrucih(mozda) kifli",
        keyPoints: keyPoints,
        type: TourType.secret);

    List<KeyPoint> animalKeyPoints = [
      KeyPoint(
          id: 1,
          name: "Katedrala",
          description:
              """Dobrodošli u tajnu turu kroz Novi Sad! Vaša avantura počinje na fascinantnom mestu bogate istorije - Katedrali u Novom Sadu. Ova impozantna građevina ne samo da predstavlja duhovni centar grada već i svedoči o različitim arhitektonskim uticajima koji su oblikovali Novi Sad.

Dok se divite grandioznoj fasadi Katedrale, evo nekoliko zanimljivosti koje biste mogli da primetite:
    1.Arhitektonski Uzorci: Obratite pažnju na detalje fasade - pronaći ćete širok spektar arhitektonskih elemenata koji predstavljaju različite stilove i epohe koje su obeležile graditeljsku tradiciju Novog Sada.
    2.Barokni Duh: Katedrala je simbol barokne umetnosti u ovom delu Evrope. Njeni izuzetni detalji i dekorativni elementi otkrivaju duh vremena u kojem je izgrađena.
    3.Kulturna Baština: Unutar Katedrale, otkrićete ne samo duhovno svetilište već i dragocenu riznicu umetničkih dela i artefakata koji svedoče o bogatoj kulturnoj baštini Novog Sada.""",

// Vaša misija na ovoj tajanstvenoj turi je da istražite četiri lokala .

// Krzo putovanje, tragovi  će vas voditi od jedne tačke do druge, pružajući vam nezaboravno iskustvo upoznavanja sa skrivenim kutkovima Novog Sada.

// HINT:"
//       U srcu grada, među mnoštvom slatkih iskušenja, postoji jedno mesto koje se ističe svojom jedinstvenošću. To je mesto gde se kreativnost i slatki ukusi spajaju u savršenom skladu.
//       U njegovom nazivu, boja noći se susreće sa simbolom neobičnosti. Potražite mesto gde crna životinja simbolizuje izuzetnost, a slatki mirisi čaroliju ukusa.
//       Pratite put slatkih snova i otkrijte tajne koje čeka mesto sa neobičnim imenom."

// Srećno u vašem istraživanju!""",
          images: [
            "https://live.staticflickr.com/7909/47358208621_d866a5513e_b.jpg"
          ],
          latitude: 45.255895,
          longitude: 19.845280),
      KeyPoint(
          id: 2,
          name: "Crna ovca",
          description:
              """U srcu grada, među mnoštvom slatkih iskušenja, postoji jedno mesto koje se ističe svojom jedinstvenošću. Kada kročite u ovu poslastičarnicu, čini se kao da ulazite u bajkoviti svet slatkih snova. Svetlošću obasjana vitrina otkriva širok spektar slatkiša, od neodoljivih torti do raznobojnih kolača, svaki od njih kao remek-delo slatke umetnosti."""

// Mirisi vanile, čokolade i voća se mešaju u vazduhu, pružajući vam osećaj topline i udobnosti. Enterijer poslastičarnice odiše elegancijom i šarmom, sa udobnim stolicama i stolovima koji vas pozivaju da zastanete i uživate u trenutku.
// """,
          ,
          images: [
            "https://gradskeinfo.rs/wp-content/uploads/2022/08/crna-ovca-sladoled-1.jpg"
          ],
          latitude: 45.255452,
          longitude: 19.845789),
      KeyPoint(
          id: 3,
          name: "Crni Ovan",
          description:
              """U srcu Novog Sada, u blizini Katedrale, nalazi se tajanstveno mesto gde se svetlost i senke susreću. U starim zidovima, skriven je kafić koji čuva duh otpora i slobode. Bez imena, ali sa bogatom istorijom, ovo mesto okuplja ljude koji cene hrabrost i solidarnost. Ovde se priče razmenjuju uz gutljaj piva, a svetlost sveća stvara toplu atmosferu. Kroz svaku čašu i razgovor, oseća se duh borbe za pravdu i slobodu koji oživljava sećanja na hrabre ljude prošlosti. """,
          images: [
            "https://lh3.googleusercontent.com/p/AF1QipMLz4yRJE7DXBF1zvMygLCKywBnIMXrPfH4gBwl=s680-w680-h510"
          ],
          latitude: 45.256845,
          longitude: 19.845256),
      KeyPoint(
          id: 4,
          name: "Gusan",
          description:
              """U srcu grada, gde svetlost izgleda kao da igra sa senkama,Tamo gde se okupljaju prijatelji, deli se smeh i razmenjuju priče u toku noći.Bez zvaničnog imena, ali s dušom koja peva svoju pesmu, Ovo mesto krije tajnu poznatu samo onima koji pažljivo slušaju.Pogledajte duboko, kroz svaki znak i trag,Gde ptice selice nalaze dom, tamo vodi put.Kroz rustičnu atmosferu i čaše piva hladne, Ovo mesto otkriva svoju tajnu svakome ko dovoljno hrabro pokuca na njegova vrata.""",
          images: ["https://www.pivnicagusan.rs/media/dostava/tocilice.jpg"],
          latitude: 45.255513,
          longitude: 19.846789),
    ];

    Tour tour3 = Tour(
        name: "Zivotinjska tura",
        description: "Otkrite zivotinje u Novom Sadu",
        keyPoints: animalKeyPoints,
        type: TourType.secret);

    tours.add(tour1);
    tours.add(tour2);
    tours.add(tour3);
    return tours;
  }
}
