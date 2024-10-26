import os
import re
from googletrans import Translator

def translate_google(text, target_language='en'):
    translator = Translator()
    try:
        translated = translator.translate(text, dest=target_language)
        return translated.text
    except Exception as e:
        print(f"翻译失败：{e}")
        return None

def translate_non_english(content, target_language='en'):
    chinese_pattern = re.compile(r'[\u4e00-\u9fff]+')
    chinese_texts = chinese_pattern.findall(content)
    unique_texts = list(set(chinese_texts))

    if not unique_texts:
        print("没有可翻译的文本。")
        return content

    translation_dict = {}
    for text in unique_texts:
        translated_text = translate_google(text, target_language)
        if translated_text:
            translation_dict[text] = translated_text

    for original, translated in translation_dict.items():
        content = content.replace(original, translated)
    
    return content

def translate_file(file_path, target_language='en'):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    translated_content = translate_non_english(content, target_language)

    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(translated_content)
    print(f"翻译成功：{file_path}")

def translate_directory(directory_path, target_language='en'):
    for root, _, files in os.walk(directory_path):
        for file in files:
            if file.endswith('.xml') or file.endswith('.sh'):  # 支持.xml和.sh文件
                file_path = os.path.join(root, file)
                print(f'正在翻译 {file_path}...')
                translate_file(file_path, target_language)

if __name__ == "__main__":
    directory = os.getcwd()  # 使用当前工作目录
    translate_directory(directory)
    print("翻译完成。")
