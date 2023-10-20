export const isPhraseComplete = (text: string, isFirst = false) => {
    const wordsAmount = text.split(' ').length;

    const specSymbols = ['?', '.', '!'];
    return wordsAmount > 40 || specSymbols.some(symbol => text.includes(symbol));
}
