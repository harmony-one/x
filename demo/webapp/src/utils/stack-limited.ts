export class StackLimited {
  limit: number;
  stack: number[];

  constructor(limit: number) {
    this.limit = limit;
    this.stack = [];
  }

  push(item: number) {
    if (this.stack.length >= this.limit) {
      this.stack.shift();
    }
    this.stack.push(item);
  }

  size() {
    // Get the number of elements in the stack
    return this.stack.length;
  }
}