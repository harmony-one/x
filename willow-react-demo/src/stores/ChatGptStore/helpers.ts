export const isPhraseComplete = (text: string, isFirst = false) => {
    const wordsAmount = text.split(' ').length;

    const specSymbols = ['?', '.', '!'];

    if (isFirst) {
        return wordsAmount > 7 || [...specSymbols, ','].some(symbol => text.includes(symbol));
    } else {
        return wordsAmount > 14 || specSymbols.some(symbol => text.includes(symbol));
    }
}