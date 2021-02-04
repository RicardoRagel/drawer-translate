#include <LanguageISOCodes.h>

using namespace std;

map<string, string> LanguageISOCodes::getLanguageList()
{
    return _lang_map;
};

// Return the name for the input language code
string LanguageISOCodes::getLanguageName(string code)
{
    return _lang_map[code];
};

// Return the code for the input language name or "None" if it's not been found
string LanguageISOCodes::getLanguageCode(string name)
{
    for (auto &i : _lang_map)
    {
        if (i.second == name) { return i.first; };
    }
    return "None";
};

map<string,string> LanguageISOCodes::_lang_map {
        {"af", "Afrikaans"},
        {"sq", "Albanian"},
        {"am", "Amharic"},
        {"ar", "Arabic"},
        {"hy", "Armenian"},
        {"az", "Azerbaijani"},
        {"eu", "Basque"},
        {"be", "Belarusian"},
        {"bn", "Bengali"},
        {"bs", "Bosnian"},
        {"bg", "Bulgarian"},
        {"ca", "Catalan"},
        {"ceb", "Cebuano"},
        {"zh-CN", "Chinese (Simplified)"},
        {"zh-TW", "Chinese (Traditional)"},
        {"co", "Corsican"},
        {"hr", "Croatian"},
        {"cs", "Czech"},
        {"da", "Danish"},
        {"nl", "Dutch"},
        {"en", "English"},
        {"eo", "Esperanto"},
        {"et", "Estonian"},
        {"fi", "Finnish"},
        {"fr", "French"},
        {"fy", "Frisian"},
        {"gl", "Galician"},
        {"ka", "Georgian"},
        {"de", "German"},
        {"el", "Greek"},
        {"gu", "Gujarati"},
        {"ht", "Haitian"},
        {"ha", "Hausa"},
        {"haw", "Hawaiian"},
        {"he /iw", "Hebrew"},
        {"hi", "Hindi"},
        {"hmn", "Hmong"},
        {"hu", "Hungarian"},
        {"is", "Icelandic"},
        {"ig", "Igbo"},
        {"id", "Indonesian"},
        {"ga", "Irish"},
        {"it", "Italian"},
        {"ja", "Japanese"},
        {"jv", "Javanese"},
        {"kn", "Kannada"},
        {"kk", "Kazakh"},
        {"km", "Khmer"},
        {"rw", "Kinyarwanda"},
        {"ko", "Korean"},
        {"ku", "Kurdish"},
        {"ky", "Kyrgyz"},
        {"lo", "Lao"},
        {"la", "Latin"},
        {"lv", "Latvian"},
        {"lt", "Lithuanian"},
        {"lb", "Luxembourgish"},
        {"mk", "Macedonian"},
        {"mg", "Malagasy"},
        {"ms", "Malay"},
        {"ml", "Malayalam"},
        {"mt", "Maltese"},
        {"mi", "Maori"},
        {"mr", "Marathi"},
        {"mn", "Mongolian"},
        {"my", "Myanmar (Burmese)"},
        {"ne", "Nepali"},
        {"no", "Norwegian"},
        {"ny", "Nyanja (Chichewa)"},
        {"or", "Odia (Oriya)"},
        {"ps", "Pashto"},
        {"fa", "Persian"},
        {"pl", "Polish"},
        {"pt", "Portuguese"},
        {"pa", "Punjabi"},
        {"ro", "Romanian"},
        {"ru", "Russian"},
        {"sm", "Samoan"},
        {"gd", "Scots (Gaelic)"},
        {"sr", "Serbian"},
        {"st", "Sesotho"},
        {"sn", "Shona"},
        {"sd", "Sindhi"},
        {"si", "Sinhala (Sinhalese)"},
        {"sk", "Slovak"},
        {"sl", "Slovenian"},
        {"so", "Somali"},
        {"es", "Spanish"},
        {"su", "Sundanese"},
        {"sw", "Swahili"},
        {"sv", "Swedish"},
        {"tl", "Tagalog (Filipino)"},
        {"tg", "Tajik"},
        {"ta", "Tamil"},
        {"tt", "Tatar"},
        {"te", "Telugu"},
        {"th", "Thai"},
        {"tr", "Turkish"},
        {"tk", "Turkmen"},
        {"uk", "Ukrainian"},
        {"ur", "Urdu"},
        {"ug", "Uyghur"},
        {"uz", "Uzbek"},
        {"vi", "Vietnamese"},
        {"cy", "Welsh"},
        {"xh", "Xhosa"},
        {"yi", "Yiddish"},
        {"yo", "Yoruba"},
        {"zu", "Zulu"}
    };
