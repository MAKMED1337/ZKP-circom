// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 16874619620571569704457367369015696851986440759399133831501978782603651748614;
    uint256 constant alphay  = 14728633656698237709748536330550638930581988291585487037017532725531097589129;
    uint256 constant betax1  = 20136989987143290130568075947726992324224321287082123784358802744835139651649;
    uint256 constant betax2  = 14271600328316772646408806814481236307197208352500058224668876447222130070180;
    uint256 constant betay1  = 2398978848134771775460285988409014345364719534173384177521856110939511782292;
    uint256 constant betay2  = 18179843974287592729861455402125206049744958285976029756108937797072811540246;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 593731339119358331494926572470290079874096353650152825305047220744788348191;
    uint256 constant deltax2 = 11143829890807174122467602979810126801717999563218754044843448350882487557019;
    uint256 constant deltay1 = 21372021784783131201711462658068188005938250596069311732274716192521429844941;
    uint256 constant deltay2 = 13115773725950341800708142772344294431605655029775405859846688944035821075919;

    
    uint256 constant IC0x = 6352605749430863798288672059004680049917250866808360996910659534488593451099;
    uint256 constant IC0y = 11974560902125108733240182483252905669595034926172269224809100773063841732600;
    
    uint256 constant IC1x = 11353828721772838439100516508082337252500188648417322234277353624157647360358;
    uint256 constant IC1y = 10418589481857332472120479482402324788568144328264392298996898050478292855204;
    
    uint256 constant IC2x = 3985939251008664915674858906068251673732365460755342218700427901880774508664;
    uint256 constant IC2y = 18506089049585499572179683224117960282045582174789622634744255072631388349384;
    
    uint256 constant IC3x = 20055185034391805053308352370632184682823186667891687338083983361129060799264;
    uint256 constant IC3y = 12188570100383604321637540873384612894849821305462527881837400087273994862236;
    
    uint256 constant IC4x = 22147215752276339630326218293004066487257193640761511465267906460631300299;
    uint256 constant IC4y = 13588886494314381322458691001239597242538439608976036558881916302814886625545;
    
    uint256 constant IC5x = 17912612405862317596700615707679035356971800046847888201851490964463988548688;
    uint256 constant IC5y = 7492184460360068594755519457597308713076430918644546922036449563188039892261;
    
    uint256 constant IC6x = 9463798493233017852699026457445125605941526714180984321416529820325025403430;
    uint256 constant IC6y = 21391299744165987568989646331456322324282109642336572096718284551448422118535;
    
    uint256 constant IC7x = 6166791220644963525047444634503294064181707314306047352929774093924957739936;
    uint256 constant IC7y = 18545140395579340251248754825826503306917188192589328335407503720411175550482;
    
    uint256 constant IC8x = 20784460449381980217973055029330169762036693978256431463548145200902128453949;
    uint256 constant IC8y = 14412827939087077875033639269382304142952084597457642774693083352226937189390;
    
    uint256 constant IC9x = 20434088412837024117811102877524080692246502174394454228404354716614511483293;
    uint256 constant IC9y = 17648816027083564080683801537552756543801876269772657794363313523544901050890;
    
    uint256 constant IC10x = 16512147088711715369213706138347836064470871713719672848407780428155137377647;
    uint256 constant IC10y = 13632801934682002138154829097738613994232740525287768791179161239538475362551;
    
    uint256 constant IC11x = 9126034336666002260389606144519835483025420248546402825521888761881804629153;
    uint256 constant IC11y = 13588391988783413621249130802038677271925441731302487405944185670599017154706;
    
    uint256 constant IC12x = 11169478879071886064366482883784758059405232267629111015908291656130374382358;
    uint256 constant IC12y = 15021676126870663112979021725231326980191458539685519631577425028332275439868;
    
    uint256 constant IC13x = 15640736412643130217551603595203429746755461208423759867115946335548858912790;
    uint256 constant IC13y = 2835898972327952121605609283850788644766877372414230247284571329640104910757;
    
    uint256 constant IC14x = 21611917062438049997952114389221699565747778495908243374886852837774799528541;
    uint256 constant IC14y = 9570716972238251088526892156578857546134643417860115887897346253238397236046;
    
    uint256 constant IC15x = 21388634116064286843757506581139775985060885062035186435009054022471439225957;
    uint256 constant IC15y = 6448104677460909172812161419784135201801522004552905251313577742723631831554;
    
    uint256 constant IC16x = 4496281960805727252746865101898299205573927149801845228604946186812722210881;
    uint256 constant IC16y = 2733661350557805286776162963907656971418322035867036931669523842698383219340;
    
    uint256 constant IC17x = 13784667964368347928887332465888500073988025115362023168235155918298116198370;
    uint256 constant IC17y = 1141875857189090652483666559580313346349179466959885249219095739051657410805;
    
    uint256 constant IC18x = 3036866701966244654752741698009904381987338823259096221066854355070847002733;
    uint256 constant IC18y = 15452105327750852321445791066486534857665450038206869827972422957621337573661;
    
    uint256 constant IC19x = 4738488523746858168811855327654390313175700869875865970598525285615592704859;
    uint256 constant IC19y = 6160402575601672614072750094292948882140860699485077887729384054643745146783;
    
    uint256 constant IC20x = 7759110625627550194331569222259366846950835943548697953443049968303752363193;
    uint256 constant IC20y = 6243862497309950220281313497237442458946228225092732583526947679409456758064;
    
    uint256 constant IC21x = 10568691738251551958327550198831355228592286913436466853580699887431759020940;
    uint256 constant IC21y = 14900726308045715062770315483133373242274139088622464831172995361065158393364;
    
    uint256 constant IC22x = 3036315828774660714348613651809135850719125690072510961853955893227104841401;
    uint256 constant IC22y = 16647218538927891225043634109113819591681457982734513578209349748818514374996;
    
    uint256 constant IC23x = 20060696859914451305982046967396374112763967449277349713713916805818183864512;
    uint256 constant IC23y = 11054835333723919636758762730455973694160761896090906685557374134883972932465;
    
    uint256 constant IC24x = 4455739470793467850835764898647386943268553552689809117916055405029840663058;
    uint256 constant IC24y = 19379546623497415271332660212245516690093467257063086099865345404386574473102;
    
    uint256 constant IC25x = 8123048795577816933239342178502559913984820820203113577814609581002729516431;
    uint256 constant IC25y = 3392795968138888544467172430538166493336574360766232663555379632574384668422;
    
    uint256 constant IC26x = 19884887289051980431091816611615365128100129239660830666299023046269985986767;
    uint256 constant IC26y = 19635923110788755757398566522817721549554999452059439311147902008085697744934;
    
    uint256 constant IC27x = 9447812809067351635204159970639074183762149303783354998861574218301443812040;
    uint256 constant IC27y = 14565079044677496339991520240515952497790006160564919189003306050241837972386;
    
    uint256 constant IC28x = 13659106118907305321546798336659065839963781857970806827692454439873508201871;
    uint256 constant IC28y = 7981013036087585370140924991438676222566912175029302302853688164572136688901;
    
    uint256 constant IC29x = 21419885759830505297642860645044705448195215119134474709536933242374087095494;
    uint256 constant IC29y = 13630174650980489107346647398328732236243770387835328591782626671958047745237;
    
    uint256 constant IC30x = 15401919573844325853501930274310066865254935306189071233924937641629096240118;
    uint256 constant IC30y = 4512165447706935367393448591502551736209321873949563588269258708755096248028;
    
    uint256 constant IC31x = 4813626351867819116761406386447688123744367016050268574635087668451277157094;
    uint256 constant IC31y = 5700915332657584005898612066751274989576144701372750676315183534878048570652;
    
    uint256 constant IC32x = 21689189274063266912885911709706997144479172562822464741569819442138250698076;
    uint256 constant IC32y = 5024910230348497474828960060295064746532073062939916347836412372858042087564;
    
    uint256 constant IC33x = 16119165308331090468431080945015043288511098481091492736683989376156422448774;
    uint256 constant IC33y = 19523137528519638272603799643637944684947439778887521176173923497529793250888;
    
    uint256 constant IC34x = 20732249829822648321029440343347594247648348402840882550416764946101499746455;
    uint256 constant IC34y = 8530772918339118619083405145243036198450671950702826249819784123401729866996;
    
    uint256 constant IC35x = 11833188878322343798016309605023877268352992293356248914161908251657566600426;
    uint256 constant IC35y = 2653996263397156935320466163070101272165571609766686244981780675694804597308;
    
    uint256 constant IC36x = 1129987141171325557577658221252513355296721885050979359804759120811520037304;
    uint256 constant IC36y = 2451049224464257127386582820577765269469482294132842279791688073104284873686;
    
    uint256 constant IC37x = 8447948561684111479648780005297544288694629017551144734570825062948327548938;
    uint256 constant IC37y = 13559028874137947577084776356131908763543651106223241369609562157631867826611;
    
    uint256 constant IC38x = 1116307531186678468561919864861421824948576993350102975389790438226759537260;
    uint256 constant IC38y = 9084859637630876025624160358267973914572429940198278380711735215296206805295;
    
    uint256 constant IC39x = 4886732147396783092048852064513609597994525832495193645332615387655211396231;
    uint256 constant IC39y = 6189619040630886237057814827930655343730883292359329843612929289630569077924;
    
    uint256 constant IC40x = 9285218780482115525062683962729340341417822287936729477662640160559022323555;
    uint256 constant IC40y = 16639804683864753469356344074881255354384617462691843456729131498207804307781;
    
    uint256 constant IC41x = 19728119431306803397354018598030949130161176424868579434553958267215074935415;
    uint256 constant IC41y = 5661928715474486929525142324268369119271254272322678866538878930193522597332;
    
    uint256 constant IC42x = 6398685421846509752085486694739752300530297916412989662085376366452233478493;
    uint256 constant IC42y = 16718963449468534697139350380086329210399843520071596694432790430379364909110;
    
    uint256 constant IC43x = 16141853464359826685561780269649101103721967249386662854814355195927742341502;
    uint256 constant IC43y = 8797404163486240615224862412605816679487146328619949997391615720767244672896;
    
    uint256 constant IC44x = 8378381796045843590733294906469130637375499526479154713681878726175252701224;
    uint256 constant IC44y = 932657381751575003321275133448382241759141567876379980834726853730411586867;
    
    uint256 constant IC45x = 3726311950665957422842022879719398276702286340040986366149578908390656915216;
    uint256 constant IC45y = 6993820228374293154896924096055632128712891025402008563073386186628919919118;
    
    uint256 constant IC46x = 16494224286602209143345127272621864809973798853951433294904818464169282719101;
    uint256 constant IC46y = 8092037306151953783471489741420068996660950592483703937698673065631515038745;
    
    uint256 constant IC47x = 14662311590500705888488347416995197442834366197831691372339083359048860208172;
    uint256 constant IC47y = 2659523305462214632975399430229094006752788182764542583634328404937434008662;
    
    uint256 constant IC48x = 18670900805624709190444893506141304843058553727704732259222491610151098489399;
    uint256 constant IC48y = 8460921145933099652293500500214493914002708462545672104346255588036002550271;
    
    uint256 constant IC49x = 15565662074392732511763421053479627120294058839878897457033037783971945267169;
    uint256 constant IC49y = 21472474087670698704091666964598228324279163179088509057398280694084992063442;
    
    uint256 constant IC50x = 1122835235044166422827685713976879034197570041260414969206700562143371101801;
    uint256 constant IC50y = 17429810167684026178932415135189975279563589710563897284312370467530042055432;
    
    uint256 constant IC51x = 6780909408338644206929181746084549803875902405348630366532545758361494973656;
    uint256 constant IC51y = 16185739129065720492826283199513215673173335803019940206613914241747935170290;
    
    uint256 constant IC52x = 8859150477710609652637017813057735329191108732311697623625819562792607546565;
    uint256 constant IC52y = 19647635022061110091575665016223949825521833708026521804541335852887362170727;
    
    uint256 constant IC53x = 9230485807969337232701749269956170551967925645439934154769828950821972763045;
    uint256 constant IC53y = 14729119636614260027205324157520330880250889059213141440590955031281547427900;
    
    uint256 constant IC54x = 7274620870604707890669524507386085070139319930346703901849625122269369386823;
    uint256 constant IC54y = 14706644793008420450009138186103032030332980571215941034983230897824364082430;
    
    uint256 constant IC55x = 16801987168419616202428221463362726981994215388116817786443341118199244299900;
    uint256 constant IC55y = 5643436098033510649967855712056829873806320756209603945049020550684313160052;
    
    uint256 constant IC56x = 10146935303313916447822760845053331927913381894591181066362092892652332898813;
    uint256 constant IC56y = 10175188563472900392371428395972997058799122116902209692986981926474429480067;
    
    uint256 constant IC57x = 14059379682413943738367157018378474040372527753037293663250609579776502496683;
    uint256 constant IC57y = 4354666487356209110037123122660710732464159320373978718486120217398782942709;
    
    uint256 constant IC58x = 7129909512492968140810761226812745348798921017808955329143451305772372553974;
    uint256 constant IC58y = 17111238882045375982028022265284893149279311427090546025489308461503215693908;
    
    uint256 constant IC59x = 12330457270293120145237621343902954115347150676197046563761832673110310822878;
    uint256 constant IC59y = 4301196625840190573262094580277875562151817034320113682419761325090901577805;
    
    uint256 constant IC60x = 19876639121747610444024157059299045309164060193096777390402765438337889368116;
    uint256 constant IC60y = 9416488388095998359160636191752765524373638499054829474375882316852736067984;
    
    uint256 constant IC61x = 3759050815015068641094923204055609802809127934614067291166737007629708644424;
    uint256 constant IC61y = 8096975481687652171180959228326514580494624667572931794427100026822683968272;
    
    uint256 constant IC62x = 18287254394716243165561631714868731388926726154100214943536798567468459983125;
    uint256 constant IC62y = 16871384593303939210554244894354067343504124765896077451419603927423471151206;
    
    uint256 constant IC63x = 10403408181471491945719755127224223512736237696975271327423271822072507674497;
    uint256 constant IC63y = 19178924139615919638396929714253541207750118743971518586407102647218819149516;
    
    uint256 constant IC64x = 16499993707105153654054603528902234928032090469111031561354974275697732244458;
    uint256 constant IC64y = 5473227012839488738449703051667485659180037674569978200843684771360561816705;
    
    uint256 constant IC65x = 9243206789314042555959547630560461206598367264150928800592736531617972887872;
    uint256 constant IC65y = 7132294367879146779050099805396469851802011957327913295429745518780172838458;
    
    uint256 constant IC66x = 20082155098364969706261278947712231988139739534983036419228179600039128073097;
    uint256 constant IC66y = 1019295233249846945531361596011085028422889042718161317868281157536533338583;
    
    uint256 constant IC67x = 954613086845895267198114480032228375496667878488527625943182596849585703959;
    uint256 constant IC67y = 16548840243036695315259493503832894404031229964228624135934618413465279486561;
    
    uint256 constant IC68x = 8257831064047484236226426462606582914354182072752050101963203925223770541756;
    uint256 constant IC68y = 4553171117672299108949451407957966715812406838823973601419964590393189730183;
    
    uint256 constant IC69x = 12253036087522393589037614884796730868122892502032048616575908601840146091580;
    uint256 constant IC69y = 7474648148587337477169487016399725523624013779771550505493935280442408684490;
    
    uint256 constant IC70x = 8590669722745942688538963511272639514131846829577187074369620259592559394425;
    uint256 constant IC70y = 10418516843074507197873712320437987745546432180082696631408472172695967420592;
    
    uint256 constant IC71x = 8128040903912871752967575556405806580094624841620196902628751870735531134895;
    uint256 constant IC71y = 7151646131603380760983386706238308975721936794577408632264596677273783908574;
    
    uint256 constant IC72x = 21235120311887354371187639102374859168331733178758034284310334858032568242069;
    uint256 constant IC72y = 19434610768640477729235719958075867284707344236262828664271194407061417591450;
    
    uint256 constant IC73x = 18076174997514946511139299529579990062978472985620375217444975590690820880071;
    uint256 constant IC73y = 7835809809874483668767287392220113931296643413929663675950638664582313919091;
    
    uint256 constant IC74x = 19213163406353933556270343604830818209638805371870423623749229981116149909493;
    uint256 constant IC74y = 47717435607865529287431119637684577158879076758801932443180450004865928682;
    
    uint256 constant IC75x = 5349216544768726669782640488419396034755897395976094123395828992814223620141;
    uint256 constant IC75y = 9381093754445144024479689192394710852558922884518806615672825709322113172481;
    
    uint256 constant IC76x = 6304997178637084567669530116235835455370989053392358247015055109685236619006;
    uint256 constant IC76y = 6660192239595081492561169391127900586996418715654343362443653115730821657427;
    
    uint256 constant IC77x = 2869805992157621454733594444412828891747234155131876804461756702999577268067;
    uint256 constant IC77y = 7109128190976844393875609035813924819185780693324860484025349625549126353356;
    
    uint256 constant IC78x = 21429201008647076727009717221031133075211786660935117833409096485760383654087;
    uint256 constant IC78y = 890326913657656864512702981604503928686244347672453913159183441009855083637;
    
    uint256 constant IC79x = 2268771504561204207147685463715394477178064786978453668127213506191879685019;
    uint256 constant IC79y = 3156365381000906989767000490662776682361891644422621461544307732796687563043;
    
    uint256 constant IC80x = 21029241389086567849220476091714227350554644201004828100142622768459720578337;
    uint256 constant IC80y = 14482223529546909196628066811527012526648735182671241879593990958660533796670;
    
    uint256 constant IC81x = 9084158608578501074068564987939934647937232107662748389667051771428025204863;
    uint256 constant IC81y = 13366832990477905293070870976169044309404828144035381874889360152785667108983;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[81] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                
                g1_mulAccC(_pVk, IC43x, IC43y, calldataload(add(pubSignals, 1344)))
                
                g1_mulAccC(_pVk, IC44x, IC44y, calldataload(add(pubSignals, 1376)))
                
                g1_mulAccC(_pVk, IC45x, IC45y, calldataload(add(pubSignals, 1408)))
                
                g1_mulAccC(_pVk, IC46x, IC46y, calldataload(add(pubSignals, 1440)))
                
                g1_mulAccC(_pVk, IC47x, IC47y, calldataload(add(pubSignals, 1472)))
                
                g1_mulAccC(_pVk, IC48x, IC48y, calldataload(add(pubSignals, 1504)))
                
                g1_mulAccC(_pVk, IC49x, IC49y, calldataload(add(pubSignals, 1536)))
                
                g1_mulAccC(_pVk, IC50x, IC50y, calldataload(add(pubSignals, 1568)))
                
                g1_mulAccC(_pVk, IC51x, IC51y, calldataload(add(pubSignals, 1600)))
                
                g1_mulAccC(_pVk, IC52x, IC52y, calldataload(add(pubSignals, 1632)))
                
                g1_mulAccC(_pVk, IC53x, IC53y, calldataload(add(pubSignals, 1664)))
                
                g1_mulAccC(_pVk, IC54x, IC54y, calldataload(add(pubSignals, 1696)))
                
                g1_mulAccC(_pVk, IC55x, IC55y, calldataload(add(pubSignals, 1728)))
                
                g1_mulAccC(_pVk, IC56x, IC56y, calldataload(add(pubSignals, 1760)))
                
                g1_mulAccC(_pVk, IC57x, IC57y, calldataload(add(pubSignals, 1792)))
                
                g1_mulAccC(_pVk, IC58x, IC58y, calldataload(add(pubSignals, 1824)))
                
                g1_mulAccC(_pVk, IC59x, IC59y, calldataload(add(pubSignals, 1856)))
                
                g1_mulAccC(_pVk, IC60x, IC60y, calldataload(add(pubSignals, 1888)))
                
                g1_mulAccC(_pVk, IC61x, IC61y, calldataload(add(pubSignals, 1920)))
                
                g1_mulAccC(_pVk, IC62x, IC62y, calldataload(add(pubSignals, 1952)))
                
                g1_mulAccC(_pVk, IC63x, IC63y, calldataload(add(pubSignals, 1984)))
                
                g1_mulAccC(_pVk, IC64x, IC64y, calldataload(add(pubSignals, 2016)))
                
                g1_mulAccC(_pVk, IC65x, IC65y, calldataload(add(pubSignals, 2048)))
                
                g1_mulAccC(_pVk, IC66x, IC66y, calldataload(add(pubSignals, 2080)))
                
                g1_mulAccC(_pVk, IC67x, IC67y, calldataload(add(pubSignals, 2112)))
                
                g1_mulAccC(_pVk, IC68x, IC68y, calldataload(add(pubSignals, 2144)))
                
                g1_mulAccC(_pVk, IC69x, IC69y, calldataload(add(pubSignals, 2176)))
                
                g1_mulAccC(_pVk, IC70x, IC70y, calldataload(add(pubSignals, 2208)))
                
                g1_mulAccC(_pVk, IC71x, IC71y, calldataload(add(pubSignals, 2240)))
                
                g1_mulAccC(_pVk, IC72x, IC72y, calldataload(add(pubSignals, 2272)))
                
                g1_mulAccC(_pVk, IC73x, IC73y, calldataload(add(pubSignals, 2304)))
                
                g1_mulAccC(_pVk, IC74x, IC74y, calldataload(add(pubSignals, 2336)))
                
                g1_mulAccC(_pVk, IC75x, IC75y, calldataload(add(pubSignals, 2368)))
                
                g1_mulAccC(_pVk, IC76x, IC76y, calldataload(add(pubSignals, 2400)))
                
                g1_mulAccC(_pVk, IC77x, IC77y, calldataload(add(pubSignals, 2432)))
                
                g1_mulAccC(_pVk, IC78x, IC78y, calldataload(add(pubSignals, 2464)))
                
                g1_mulAccC(_pVk, IC79x, IC79y, calldataload(add(pubSignals, 2496)))
                
                g1_mulAccC(_pVk, IC80x, IC80y, calldataload(add(pubSignals, 2528)))
                
                g1_mulAccC(_pVk, IC81x, IC81y, calldataload(add(pubSignals, 2560)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            
            checkField(calldataload(add(_pubSignals, 1280)))
            
            checkField(calldataload(add(_pubSignals, 1312)))
            
            checkField(calldataload(add(_pubSignals, 1344)))
            
            checkField(calldataload(add(_pubSignals, 1376)))
            
            checkField(calldataload(add(_pubSignals, 1408)))
            
            checkField(calldataload(add(_pubSignals, 1440)))
            
            checkField(calldataload(add(_pubSignals, 1472)))
            
            checkField(calldataload(add(_pubSignals, 1504)))
            
            checkField(calldataload(add(_pubSignals, 1536)))
            
            checkField(calldataload(add(_pubSignals, 1568)))
            
            checkField(calldataload(add(_pubSignals, 1600)))
            
            checkField(calldataload(add(_pubSignals, 1632)))
            
            checkField(calldataload(add(_pubSignals, 1664)))
            
            checkField(calldataload(add(_pubSignals, 1696)))
            
            checkField(calldataload(add(_pubSignals, 1728)))
            
            checkField(calldataload(add(_pubSignals, 1760)))
            
            checkField(calldataload(add(_pubSignals, 1792)))
            
            checkField(calldataload(add(_pubSignals, 1824)))
            
            checkField(calldataload(add(_pubSignals, 1856)))
            
            checkField(calldataload(add(_pubSignals, 1888)))
            
            checkField(calldataload(add(_pubSignals, 1920)))
            
            checkField(calldataload(add(_pubSignals, 1952)))
            
            checkField(calldataload(add(_pubSignals, 1984)))
            
            checkField(calldataload(add(_pubSignals, 2016)))
            
            checkField(calldataload(add(_pubSignals, 2048)))
            
            checkField(calldataload(add(_pubSignals, 2080)))
            
            checkField(calldataload(add(_pubSignals, 2112)))
            
            checkField(calldataload(add(_pubSignals, 2144)))
            
            checkField(calldataload(add(_pubSignals, 2176)))
            
            checkField(calldataload(add(_pubSignals, 2208)))
            
            checkField(calldataload(add(_pubSignals, 2240)))
            
            checkField(calldataload(add(_pubSignals, 2272)))
            
            checkField(calldataload(add(_pubSignals, 2304)))
            
            checkField(calldataload(add(_pubSignals, 2336)))
            
            checkField(calldataload(add(_pubSignals, 2368)))
            
            checkField(calldataload(add(_pubSignals, 2400)))
            
            checkField(calldataload(add(_pubSignals, 2432)))
            
            checkField(calldataload(add(_pubSignals, 2464)))
            
            checkField(calldataload(add(_pubSignals, 2496)))
            
            checkField(calldataload(add(_pubSignals, 2528)))
            
            checkField(calldataload(add(_pubSignals, 2560)))
            
            checkField(calldataload(add(_pubSignals, 2592)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
