import { describe, expect, it } from "vitest";
import {
  classificationTier,
  fontFamily,
  gold,
  indigo,
  membershipTier,
  neutral,
  register,
  violet,
} from "./index.js";

describe("@ardtire/tokens", () => {
  describe("color palettes", () => {
    it("indigo palette has all required stops", () => {
      const stops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950] as const;
      for (const stop of stops) {
        expect(indigo[stop]).toMatch(/^#[0-9a-f]{6}$/i);
      }
    });

    it("violet palette has all required stops", () => {
      const stops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950] as const;
      for (const stop of stops) {
        expect(violet[stop]).toMatch(/^#[0-9a-f]{6}$/i);
      }
    });

    it("gold palette has all required stops", () => {
      const stops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950] as const;
      for (const stop of stops) {
        expect(gold[stop]).toMatch(/^#[0-9a-f]{6}$/i);
      }
    });

    it("neutral palette includes 0 and 1000 sentinel values", () => {
      expect(neutral[0]).toBe("#ffffff");
      expect(neutral[1000]).toBe("#000000");
    });
  });

  describe("register tokens", () => {
    it("exterior register has all required keys", () => {
      expect(register.exterior).toHaveProperty("bg");
      expect(register.exterior).toHaveProperty("surface");
      expect(register.exterior).toHaveProperty("border");
      expect(register.exterior).toHaveProperty("accent");
      expect(register.exterior).toHaveProperty("accentFg");
      expect(register.exterior).toHaveProperty("text");
    });

    it("interior register has all required keys", () => {
      expect(register.interior).toHaveProperty("bg");
      expect(register.interior).toHaveProperty("surface");
      expect(register.interior).toHaveProperty("border");
      expect(register.interior).toHaveProperty("accent");
      expect(register.interior).toHaveProperty("accentFg");
      expect(register.interior).toHaveProperty("text");
    });

    it("exterior accent is indigo-600", () => {
      expect(register.exterior.accent).toBe(indigo[600]);
    });

    it("interior accent is gold-400", () => {
      expect(register.interior.accent).toBe(gold[400]);
    });
  });

  describe("typography", () => {
    it("font families are defined", () => {
      expect(fontFamily.sans).toBeTruthy();
      expect(fontFamily.serif).toBeTruthy();
      expect(fontFamily.mono).toBeTruthy();
    });
  });

  describe("classification tiers", () => {
    it("has all five tiers T0–T4", () => {
      expect(classificationTier.T0.level).toBe(0);
      expect(classificationTier.T1.level).toBe(1);
      expect(classificationTier.T2.level).toBe(2);
      expect(classificationTier.T3.level).toBe(3);
      expect(classificationTier.T4.level).toBe(4);
    });

    it("T4 is Constitutional", () => {
      expect(classificationTier.T4.label).toBe("Constitutional");
    });
  });

  describe("membership tiers", () => {
    it("has associate and full tiers", () => {
      expect(membershipTier.associate.level).toBe(0);
      expect(membershipTier.full.level).toBe(1);
    });
  });
});
